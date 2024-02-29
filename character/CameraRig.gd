extends Node3D

@export_range(0.0, 5.0, 0.01, "or_greater", "suffix:m") var spring_length: float = 3.0
@export var cast_sphere: bool = true

@onready var pitch_anchor: = $CameraPitch
@onready var spring_arm: SpringArm3D = $CameraPitch/SpringArm3D
@onready var camera: Camera3D = $CameraPitch/SpringArm3D/Camera3D

var mouse_sens = 4.0
var fmod_listener: FmodListener3D

func _ready() -> void:
	spring_arm.add_excluded_object((get_parent_node_3d() as PhysicsBody3D).get_rid())
	spring_arm.spring_length = spring_length
	if !cast_sphere:
		spring_arm.shape = null

func _process(delta: float) -> void:
	#DebugOverlay.display({ arm_length = spring_arm.get_hit_length() }, self)
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var mouse_displacement = - event.relative / get_tree().root.size.y
		rotate_y(mouse_displacement.x * mouse_sens)
		pitch_anchor.rotate_x(mouse_displacement.y * mouse_sens)
		pitch_anchor.rotation.x = clamp(pitch_anchor.rotation.x, -0.25 * TAU, 0.25 * TAU)

func activate() -> void:
	camera.make_current()
	spring_arm.set_physics_process_internal(true)
	fmod_listener = FmodListener3D.new()
	fmod_listener.listener_index = 0
	fmod_listener.scale_object_local(Vector3(-1.0, 1.0, 1.0))
	add_child(fmod_listener)
	set_process_unhandled_input(true)

func deactivate() -> void:
	set_process_unhandled_input(false)
	if fmod_listener:
		remove_child(fmod_listener)
		fmod_listener.queue_free()
		fmod_listener = null
	spring_arm.set_physics_process_internal(false)
