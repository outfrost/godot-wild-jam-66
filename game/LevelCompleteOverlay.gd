extends Control

signal dismissed

@onready var slide: Control = $Slide

func _ready() -> void:
	$Slide/ContinueButton.pressed.connect(dismiss)

func display(prop_name: String) -> void:
	$Slide/LevelPropLabel.text = "%s made it out!" % prop_name
	slide.position.x = 2 * slide.size.x
	show()
	var tween: = slide.create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(slide, ^"position", Vector2(0, 0), 1.0).set_ease(Tween.EASE_OUT)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func dismiss() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
	dismissed.emit()
