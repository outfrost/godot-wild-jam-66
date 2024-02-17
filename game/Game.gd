class_name Game
extends Node

@export var room_scn: PackedScene

@onready var main_menu: Control = $UI/MainMenu
@onready var transition_screen: TransitionScreen = $UI/TransitionScreen
@onready var menu_background: Node = $MenuBackground
@onready var menu_background_content: Node = menu_background.get_child(0)
@onready var music: = $Music

var debug: RefCounted

var room: Room

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
	menu_background.remove_child(menu_background_content)
	room = room_scn.instantiate()
	add_child(room)
	room.prop_finished.connect(prop_finished)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	room.activate_next_prop()
	music.set_parameter("SCENE", 1)
	music.set_parameter("SCENE", 0)

func back_to_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	remove_child(room)
	room.queue_free()
	Harbinger.prune()
	music.set_parameter("SCENE", 0)
	menu_background.add_child(menu_background_content)
	main_menu.show()

func prop_finished() -> void:
	room.activate_next_prop()
	music.set_parameter("SCENE", 1)
	music.set_parameter("SCENE", 0)
