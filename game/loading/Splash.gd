extends Control

const GAME: PackedScene = preload("res://game/Game.tscn")

func _ready() -> void:
	if OS.has_feature("debug") && FileAccess.file_exists("res://debug.gd"):
		var debug_script: GDScript = load("res://debug.gd")
		if debug_script:
			if (debug_script.get_script_constant_map() as Dictionary).get("SKIP_SPLASH", false):
				get_tree().call_deferred("change_scene_to_packed", GAME)

	get_tree().create_timer(2.0).timeout.connect(func():
		$AudioStreamPlayer.play()
		$Godot.show()
		get_tree().create_timer(2.5).timeout.connect(func():
			$InsideTheBox.offset_left = 0.0
			$InsideTheBox.offset_right = 0.0
			var tween: = create_tween().set_trans(Tween.TRANS_EXPO).set_parallel()
			tween.tween_property($Godot, ^"offset_left", 0.0, 0.5).set_ease(Tween.EASE_IN)
			tween.tween_property($Godot, ^"offset_right", 0.0, 0.5).set_ease(Tween.EASE_IN)
			tween.set_parallel(false)
			tween.step_finished.connect(func(i):
				if i == 0:
					$Godot.hide()
					$InsideTheBox.show()
			)
			tween.tween_property($InsideTheBox, ^"offset_left", -140.0, 0.5).set_ease(Tween.EASE_OUT)
			tween.set_parallel()
			tween.tween_property($InsideTheBox, ^"offset_right", 140.0, 0.5).set_ease(Tween.EASE_OUT)
			tween.play()
			get_tree().create_timer(3.0).timeout.connect(func():
				get_tree().change_scene_to_packed(GAME)
			)
		)
	)
