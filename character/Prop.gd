extends CharacterBody3D

@export var speed = 1.0
@export var acceleration = 4.0
@export var deceleration = 10.0
@export var jump_speed = 2.7

@export var mouse_sens = 0.01
@export var rotation_speed = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_speed

	var input_dir: = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var velocity_xz: = Vector2(velocity.x, velocity.z)
	if input_dir:
		var direction: = input_dir.rotated(rotation_degrees.y).limit_length(1.0)
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

#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#spring_arm.rotation.x -= event.relative.y * mouse_sens
		#spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0) #-90 is straight down, 30 is degrees up
		#spring_arm.rotation.y -= event.relative.x * mouse_sens
