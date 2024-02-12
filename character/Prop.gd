class_name Prop
extends CharacterBody3D

@export var visual: Node3D
@export var camera_rig: Node3D

@export var speed: = 1.0
@export var acceleration: = 4.0
@export var deceleration: = 10.0
@export var jump_speed: = 2.7
@export var rotation_speed: = 10.0

@onready var visual_base_pos: = visual.position
@onready var visual_base_rot: = visual.rotation.y
@onready var camera_rig_base_pos: = camera_rig.position

var active: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_delta: = Vector3.ZERO
var rotation_delta: = 0.0

func _ready() -> void:
	deactivate()
	collision_layer = 1 << 1 # props

func _process(delta: float) -> void:
	# interpolate movement to prevent stutters
	var displacement: = transform.basis.inverse() * movement_delta
	var correction: = displacement * (-1.0 + Engine.get_physics_interpolation_fraction())
	visual.position = visual_base_pos + correction
	camera_rig.position = camera_rig_base_pos + correction

	# interpolate rotation
	var rot_correction: = rotation_delta * (-1.0 + Engine.get_physics_interpolation_fraction())
	visual.rotation.y = visual_base_rot + rot_correction

	#DebugOverlay.display([rotation.y, camera_rig.rotation.y], self)

func _physics_process(delta: float) -> void:
	var last_pos: = transform.origin
	var last_rot: = rotation.y

	if !is_on_floor():
		velocity.y -= gravity * delta

	if active:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			velocity.y = jump_speed

		if Input.get_action_strength("move_forward") > 0.0:
			var slerp_rate: = rotation_speed * (0.25 + 0.5 * (cos(camera_rig.rotation.y) + 1.0)) * delta
			var new_rotation_y: = lerp_angle(rotation.y, rotation.y + camera_rig.rotation.y, slerp_rate)
			camera_rig.rotate_y(rotation.y - new_rotation_y)
			rotation.y = new_rotation_y

		var input_dir: = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var velocity_xz: = Vector2(velocity.x, velocity.z)
		if input_dir:
			var direction: = input_dir.rotated(- camera_rig.rotation.y).rotated(- rotation.y).limit_length(1.0)
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
	rotation_delta = wrapf(rotation.y - last_rot, - 0.5 * TAU, 0.5 * TAU)

func activate() -> void:
	camera_rig.get_node(^"CameraPitch/Camera3D").make_current()
	#set_process(true)
	#set_physics_process(true)
	camera_rig.set_process_unhandled_input(true)
	active = true

func deactivate() -> void:
	active = false
	velocity = Vector3.ZERO
	#set_process(false)
	#set_physics_process(false)
	camera_rig.set_process_unhandled_input(false)
