class_name Prop
extends CharacterBody3D

@export var friendlyname: String = "Prop"
@export var visual: Node3D

@export var speed: = 1.0
@export var acceleration: = 4.0
@export var deceleration: = 10.0
@export var jump_speed: = 3.0
@export var rotation_speed: = 10.0

@onready var camera_rig: Node3D = $CameraRig
@onready var camera_rig_base_pos: = camera_rig.position

@onready var visual_base_pos: = visual.position
@onready var visual_base_rot: = visual.rotation.y

@onready var sfx_jump: FmodEventEmitter3D = $SfxJump
@onready var sfx_fall: FmodEventEmitter3D = $SfxFall

@onready var starting_xform: = transform

var active: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_delta: = Vector3.ZERO
var rotation_delta: = 0.0

func _ready() -> void:
	deactivate()
	collision_layer = 1 << 1 # props
	collision_mask = 1 << 0 | 1 << 1 # general, props

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
	#DebugOverlay.display({ velocity = velocity }, self)

func _physics_process(delta: float) -> void:
	var last_pos: = transform.origin
	var last_rot: = rotation.y

	if !is_on_floor():
		velocity.y -= gravity * delta

	if active:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			sfx_jump.play()
			velocity.y = jump_speed

		#region rotate to face forward
		if Input.get_action_strength("move_forward") > 0.0:
			var slerp_rate: = rotation_speed * (0.25 + 0.5 * (cos(camera_rig.rotation.y) + 1.0)) * delta
			var new_rotation_y: = lerp_angle(rotation.y, rotation.y + camera_rig.rotation.y, slerp_rate)

			# prevent jitter/wiggle at low physics framerates
			if (
				abs(wrapf(angle_difference(rotation.y, new_rotation_y), - TAU * 0.5, TAU * 0.5))
				> abs(wrapf(camera_rig.rotation.y, - TAU * 0.5, TAU * 0.5))
			):
				new_rotation_y = rotation.y + camera_rig.rotation.y

			camera_rig.rotate_y(rotation.y - new_rotation_y)
			rotation.y = new_rotation_y
		#endregion

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

	var velocity_tmp: = velocity

	move_and_slide()

	#for i in range(get_slide_collision_count()):
		#if get_slide_collision(i).get_normal().y * velocity_tmp.y < - jump_speed + 0.05:
			#sfx_fall.play()

	movement_delta = transform.origin - last_pos
	rotation_delta = wrapf(rotation.y - last_rot, - 0.5 * TAU, 0.5 * TAU)

func activate() -> void:
	camera_rig.activate()
	active = true

func deactivate() -> void:
	active = false
	velocity = Vector3.ZERO
	camera_rig.deactivate()

func reset() -> void:
	transform = starting_xform
	velocity = Vector3.ZERO
