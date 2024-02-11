extends CharacterBody3D

@export var visual: Node3D
@export var camera_anchor: Node3D

@export var speed = 1.0
@export var acceleration = 4.0
@export var deceleration = 10.0
@export var jump_speed = 2.7
@export var rotation_speed = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_delta: = Vector3.ZERO

@onready var visual_base_pos: = visual.position
@onready var camera_anchor_base_pos: = camera_anchor.position

func _process(delta: float) -> void:
	# interpolate movement to prevent stutters
	var displacement: = transform.basis.inverse() * movement_delta
	var correction: = displacement * (-1.0 + Engine.get_physics_interpolation_fraction())
	visual.position = visual_base_pos + correction
	camera_anchor.position = camera_anchor_base_pos + correction

	DebugOverlay.display(rotation.y)
	DebugOverlay.display(camera_anchor.rotation.y)

func _physics_process(delta: float) -> void:
	var last_pos: = transform.origin

	if !is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_speed

	if Input.get_action_strength("move_forward") > 0.0:
		var new_rotation_y: = rotate_toward(rotation.y, rotation.y + camera_anchor.rotation.y, rotation_speed * delta)
		camera_anchor.rotate_y(rotation.y - new_rotation_y)
		rotation.y = new_rotation_y

	var input_dir: = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var velocity_xz: = Vector2(velocity.x, velocity.z)
	if input_dir:
		var direction: = input_dir.rotated(- camera_anchor.rotation.y).rotated(- rotation.y).limit_length(1.0)
		if direction.dot(velocity_xz) > 0.4:
			velocity_xz = velocity_xz.move_toward(direction * speed, acceleration * delta)
		else:
			velocity_xz = velocity_xz.move_toward(direction * speed, deceleration * delta)
		velocity_xz = velocity_xz.limit_length(speed)
	else:
		velocity_xz = velocity_xz.move_toward(Vector2.ZERO, deceleration * delta)
	velocity.x = velocity_xz.x
	velocity.z = velocity_xz.y

	move_and_slide()

	movement_delta = transform.origin - last_pos
