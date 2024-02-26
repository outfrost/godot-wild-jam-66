extends FmodEventEmitter2D



func _on_play_button_pressed():
	%SFX_Click.play()

func _on_credits_button_pressed():
	%SFX_Click.play()
	
func _on_close_button_pressed():
	%SFX_Click.play()

func _on_choose_level_button_pressed():
	%SFX_Click.play()

func _on_options_button_pressed():
	%SFX_Click.play()

func _on_quit_button_pressed():
	%SFX_Click.play()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		%SFX_Click.play()

func _on_rich_text_label_meta_clicked(meta):
	%SFX_Click.play()


func _on_rich_text_label_2_meta_clicked(meta):
	%SFX_Click.play()
