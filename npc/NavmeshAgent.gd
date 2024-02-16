extends CharacterBody3D


@export var speed = 5.0
@export var acceleration = 20.0
@export var rotation_speed: = 10.0

var next_path_position: Vector3
var current_agent_position: Vector3 = global_position

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var raycaster: Node3D = $BasicEmployee
@onready var route: Node = $"Patrol"

@export var freeze_time: float = 5.0 #i think this is in seconds?
@export var loop: bool = true
var target: Marker3D
var index: int = 0
var growing: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var vy: float

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

func move_toward_target(delta, target):
	if navigation_agent.is_navigation_finished():
		set_movement_target(target.global_position)
	current_agent_position = global_position
	next_path_position = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * speed

func select_target():
	target = route.get_child(index)
	#await get_tree().create_timer(freeze_time).timeout
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


func _physics_process(delta):

	#route and loop to select next target
	if navigation_agent.is_navigation_finished():
		#await get_tree().create_timer(freeze_time).timeout
		select_target()
		move_toward_target(delta,target)
		return


	# calculate jumping, and remember the y velocity, then do x,z calculations
	if !is_on_floor():
		velocity.y -= gravity * delta
		vy = velocity.y
	move_toward_target(delta,target)
	velocity.y = vy

	#add some nice lerping to this?

	#because idk how to lerp this stuff
	if (position - next_path_position).length() > 0.5:
		look_at(next_path_position,Vector3.UP)

	move_and_slide()
