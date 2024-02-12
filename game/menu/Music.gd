extends FmodEventEmitter2D

func _on_play_button_pressed():
	if Input.is_action_pressed("PlayButton"):
		self["event_parameter/SCENE/value"] = self["event_parameter/SCENE/value"] + 1
