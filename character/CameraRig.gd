extends Node3D

@onready var pitch_anchor: = $CameraPitch

var mouse_sens = 4.0

func _process(delta: float) -> void:
	#DebugOverlay.display(str(pitch_anchor.rotation.x))
	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var mouse_displacement = - event.relative / get_tree().root.size.y
		rotate_y(mouse_displacement.x * mouse_sens)
		pitch_anchor.rotate_x(mouse_displacement.y * mouse_sens)
		pitch_anchor.rotation.x = clamp(pitch_anchor.rotation.x, -0.25 * TAU, 0.25 * TAU)
