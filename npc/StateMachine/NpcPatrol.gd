extends State
class_name NpcPatrol

signal alerted

@export var speed = 5.0
@export var acceleration = 20.0
@export var rotation_speed: = 10.0
@export var parent: CharacterBody3D

var next_path_position: Vector3
var current_agent_position: Vector3

@export var raycaster: Node3D
var route: Node
var navigation_agent: NavigationAgent3D

@export var loop: bool = true
var target: Marker3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var vy: float
var index: int = 0
var growing: bool = true

func _ready():
	set_physics_process(false)

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	set_physics_process(true)

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func move_toward_target(delta, target):
	if navigation_agent.is_navigation_finished():
		set_movement_target(target.global_position)
	current_agent_position = parent.position
	next_path_position = navigation_agent.get_next_path_position()
	parent.velocity = current_agent_position.direction_to(next_path_position) * speed

func select_target():
	target = route.get_child(index)
	if growing:
		index += 1
	else:
		index -= 1
	if loop:
		# we are looping, we can go 0-n again
		if index > route.get_child_count() - 1:
			index = 0
	else :
		#we aren't, we need to switch direction
		if index > route.get_child_count() - 1:
			index -= 2
			growing = false
		if index < 0:
			index += 2
			growing = true

func Enter():
	parent.velocity.x = 0
	parent.velocity.z = 0
	target = route.get_child(index)
	set_movement_target(target.global_position)
	raycaster.use_normal_profile()

func Physics_Update(delta):

	if !navigation_agent:
		return

	#route and loop to select next target
	if navigation_agent.is_navigation_finished():
		Transitioned.emit(self, "WaitState")
		select_target()

	#rotation
	var to_next_path_pos_local: = parent.to_local(next_path_position)
	if to_next_path_pos_local.length_squared() > 0.25:
		var angle: = Vector3.FORWARD.signed_angle_to(to_next_path_pos_local, Vector3.UP)

		var slerp_rate: float = clamp(8.0 * (0.25 + 0.5 * (cos(angle) + 1.0)) * delta, 0.0, 1.0)
		var new_rotation_y: = lerp_angle(parent.rotation.y, parent.rotation.y + angle, slerp_rate)

		# prevent jitter/wiggle at low physics framerates
		if abs(angle_difference(parent.rotation.y, new_rotation_y)) > abs(angle):
			new_rotation_y = parent.rotation.y + angle

		parent.rotation.y = new_rotation_y

	# calculate jumping, and remember the y velocity, then do x,z calculations
	if !parent.is_on_floor():
		parent.velocity.y -= gravity * delta
		vy = parent.velocity.y
	move_toward_target(delta,target)
	parent.velocity.y = vy

	#if player is detected, switch to chase state (could add suspicious state)
	if raycaster.detected >= 1.0:
		alerted.emit()
		Transitioned.emit(self, "ChaseState")

func Update(delta):
	pass
