extends Control

@onready var slide: Control = $Slide

func display(prop_name: String) -> void:
	$Slide/LevelPropLabel.text = "%s made it out!" % prop_name
	var tween: = slide.create_tween()
	#tween.tween_property(slide, anchor)
