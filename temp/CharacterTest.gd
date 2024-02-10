extends CharacterBody3D


@export var speed = 10.0
@export var acceleration = 1.0
@export var deceleration = 25.0
@export var jump_speed = 8.0

@export var mouse_sens = 0.01
@export var rotation_speed = 12.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var spring_arm = $SpringArm3D
@onready var model = $model


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_speed
	
	
	get_horizontal_move(delta)
	
	if velocity.length() > 1.0:
		model.rotation.y = lerp(model.rotation.y, spring_arm.rotation.y, rotation_speed * delta)
	
	move_and_slide()


func get_horizontal_move(delta):
	# Get the input direction and handle the movement/deceleration.
	var vy = velocity.y
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, spring_arm.rotation.y)
	
	## these 2 have the same effect
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	velocity.lerp(direction * speed, acceleration * delta)
	
	#if the length of desired movement is smaller than actual movement, use decelleration
	#if (input_dir.length() * speed) < velocity.length():
		#velocity = lerp(velocity, direction * speed, deceleration * delta)
	#else:
		#velocity.lerp(direction * speed, acceleration * delta)
	
	
	if direction.dot(velocity) < 0 or direction == Vector3.ZERO:
		velocity = lerp(velocity, direction * speed, deceleration * delta)
	else:
		velocity.lerp(direction * speed, acceleration * delta)
	
	# we didn't wanna change the y velocity in this method
	velocity.y = vy


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sens
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0) #-90 is straight down, 30 is degrees up
		spring_arm.rotation.y -= event.relative.x * mouse_sens
