extends CharacterBody3D

signal alerted
signal chase_start
signal chase_end
signal lost_track

enum EmployeeState {
	Patrol,
	Wait,
	Chase,
}

@export var navigation_agent : NavigationAgent3D
@export var raycaster: Node3D
@export var route : Node
@export var patrol_speed : float
@export var ping_pong_path : bool
@export var wait_time : float
@export var chase_speed : float

@onready var starting_xform: = transform

var state: EmployeeState = EmployeeState.Patrol
var prop: Prop

@export var loop: bool = true
var patrol_node_index: int = 0
var patrol_index_growing: bool = true

var wait_time_remaining: float

var target: Marker3D
@onready var last_position: Marker3D = $LastPos

var next_path_position: Vector3
var current_agent_position: Vector3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var sfx_lost_track_played: bool = false

#@onready var debug: = DebugOverlay.tracker(self)

func _ready():
	assert(navigation_agent)

	$CatchArea.body_entered.connect(func(body):
		if prop && body == prop && state == EmployeeState.Chase:
			$BasicEmployee/SfxPlayerCaught.play()
			Harbinger.dispatch("prop_caught", [self.name])
	)

	Harbinger.subscribe("active_prop", active_prop)
	Harbinger.subscribe("npc_reset", reset)

	enter_patrol()

	#debug.trace("state").trace("patrol_index_growing").trace("patrol_node_index")

func _process(delta: float) -> void:
	#debug.print("target: " + target.name)
	#debug.print("is_navigation_finished: " + str(navigation_agent.is_navigation_finished()))
	pass

func _physics_process(delta):
	var vy: = 0.0
	if !is_on_floor():
		velocity.y -= gravity * delta
		vy = velocity.y

	match state:
		EmployeeState.Patrol:
			navigate_patrol(delta, target)
			if navigation_agent.is_navigation_finished():
				#route and loop to select next target
				select_target()
				enter_wait()

			#if player is detected, switch to chase state (could add suspicious state)
			if raycaster.detected >= 1.0:
				alerted.emit()
				enter_chase()

		EmployeeState.Wait:
			velocity = Vector3.ZERO

			if raycaster.detected >= 1.0:
				alerted.emit()
				enter_chase()

			wait_time_remaining -= delta
			if wait_time_remaining <= 0.0:
				enter_patrol()

		EmployeeState.Chase:
			if raycaster.line_of_sight:
				last_position.global_position = raycaster.prop_last_pos
				sfx_lost_track_played = false

			if raycaster.line_of_sight || raycaster.detected >= 0.1:
				navigate_chase(delta)
			else:
				chase_end.emit()
				enter_patrol()

			if (
				!sfx_lost_track_played
				&& navigation_agent.is_navigation_finished()
				&& !raycaster.line_of_sight
			):
				sfx_lost_track_played = true
				lost_track.emit()

	velocity.y = vy

	#rotation
	var to_next_path_pos_local: = to_local(next_path_position)
	if to_next_path_pos_local.length_squared() > 0.25:
		var angle: = Vector3.FORWARD.signed_angle_to(to_next_path_pos_local, Vector3.UP)

		var slerp_rate: float = clamp(8.0 * (0.25 + 0.5 * (cos(angle) + 1.0)) * delta, 0.0, 1.0)
		var new_rotation_y: = lerp_angle(rotation.y, rotation.y + angle, slerp_rate)

		# prevent jitter/wiggle at low physics framerates
		if abs(angle_difference(rotation.y, new_rotation_y)) > abs(angle):
			new_rotation_y = rotation.y + angle

		rotation.y = new_rotation_y

	move_and_slide()

func enter_patrol() -> void:
	state = EmployeeState.Patrol
	target = route.get_child(patrol_node_index)
	raycaster.use_normal_profile()

func enter_wait() -> void:
	state = EmployeeState.Wait
	wait_time_remaining = wait_time

func enter_chase() -> void:
	state = EmployeeState.Chase
	sfx_lost_track_played = false
	chase_start.emit()
	raycaster.use_chase_profile()

func active_prop(p) -> void:
	prop = p[0]

func reset(_p) -> void:
	transform = starting_xform
	velocity = Vector3.ZERO
	patrol_node_index = 0
	patrol_index_growing = true
	enter_patrol()

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func navigate_patrol(delta, target):
	if navigation_agent.is_navigation_finished():
		set_movement_target(target.global_position)
	current_agent_position = position
	next_path_position = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * patrol_speed

func navigate_chase(delta):
	navigation_agent.set_target_position(last_position.global_position)
	current_agent_position = position
	next_path_position = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * chase_speed

func select_target():
	target = route.get_child(patrol_node_index)
	if patrol_index_growing:
		patrol_node_index += 1
	else:
		patrol_node_index -= 1
	if loop:
		# we are looping, we can go 0-n again
		if patrol_node_index > route.get_child_count() - 1:
			patrol_node_index = 0
	else :
		#we aren't, we need to switch direction
		if patrol_node_index > route.get_child_count() - 1:
			patrol_node_index -= 2
			patrol_index_growing = false
		if patrol_node_index < 0:
			patrol_node_index += 2
			patrol_index_growing = true
