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
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	#navigation_agent.path_desired_distance = 0.5
	#navigation_agent.target_desired_distance = 0.5

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

func Physics_Update(delta):

	if !navigation_agent:
		return

	#route and loop to select next target
	if navigation_agent.is_navigation_finished():
		Transitioned.emit(self, "WaitState")
		select_target()


	# calculate jumping, and remember the y velocity, then do x,z calculations
	if !parent.is_on_floor():
		parent.velocity.y -= gravity * delta
		vy = parent.velocity.y
	move_toward_target(delta,target)
	parent.velocity.y = vy

	#rotation
	if (parent.position - next_path_position).length() > 0.5:
		parent.look_at(next_path_position,Vector3.UP)

	#if player is detected, switch to chase state (could add suspicious state)
	if raycaster.detected >= 0.9:
		alerted.emit()
		Transitioned.emit(self, "ChaseState")

func Update(delta):
	pass
