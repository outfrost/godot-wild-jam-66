extends CharacterBody3D


@export var speed = 5.0
@export var acceleration = 20.0
@export var target: Marker3D

var next_path_position: Vector3
var current_agent_position: Vector3 = global_position

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	set_physics_process(false)
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)

func set_movement_target(movement_target: Vector3):
	#keeping this in to add rotation logic maybe?
	navigation_agent.set_target_position(movement_target)

func move_toward_target(delta):
	var direction = Vector3()
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, acceleration * delta)

func _physics_process(delta):

	#var direction = Vector3()
	#direction = navigation_agent.get_next_path_position() - global_position
	#direction = direction.normalized()
#
	#velocity = velocity.lerp(direction * speed, acceleration * delta)


	#if !navigation_agent.is_navigation_finished():
		#move_toward_target(delta)
	#else:
		#set_movement_target(target.global_position)
	#if it thinks navigation is finished, path again
	if navigation_agent.is_navigation_finished():
		set_movement_target(target.global_position)
	current_agent_position = global_position
	next_path_position = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * speed

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		set_movement_target(target.global_position)
