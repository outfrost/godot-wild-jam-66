class_name Game
extends Node

@onready var main_menu: Control = $UI/MainMenu
@onready var transition_screen: TransitionScreen = $UI/TransitionScreen
@onready var menu_background: Node = $MenuBackground
@onready var music: = $Music

var debug: RefCounted

var scene: Room

func _ready() -> void:
	if OS.has_feature("debug") && FileAccess.file_exists("res://debug.gd"):
		var debug_script: GDScript = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.start_game.connect(on_start_game)

func _process(delta: float) -> void:
	DebugOverlay.display("fps %d" % Performance.get_monitor(Performance.TIME_FPS), null, true)

	if Input.is_action_just_pressed("menu"):
		back_to_menu()

func on_start_game() -> void:
	main_menu.hide()
	menu_background.hide()
	scene = load("res://scene/prototype/PrototypeRoom.tscn").instantiate()
	add_child(scene)
	scene.prop_finished.connect(prop_finished)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	scene.activate_next_prop()
	music.set_parameter("SCENE", 1)
	music.set_parameter("SCENE", 0)

func back_to_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	remove_child(scene)
	scene.queue_free()
	music.set_parameter("SCENE", 0)
	menu_background.show()
	main_menu.show()

func prop_finished() -> void:
	scene.activate_next_prop()
	music.set_parameter("SCENE", 1)
	music.set_parameter("SCENE", 0)
