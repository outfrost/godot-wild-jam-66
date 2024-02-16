extends FmodEventEmitter2D



func _on_play_button_pressed():
	%UI_Click.play()

func _on_credits_button_pressed():
	%UI_Click.play()
	
func _on_close_button_pressed():
	%UI_Click.play()

func _on_choose_level_button_pressed():
	%UI_Click.play()

func _on_options_button_pressed():
	%UI_Click.play()

func _on_quit_button_pressed():
	%UI_Click.play()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		%UI_Click.play()
