class_name Game
extends Node

@export var room_scn: PackedScene

@onready var main_menu: Control = $UI/MainMenu
@onready var transition_screen: TransitionScreen = $UI/TransitionScreen
@onready var level_complete_overlay: Control = $UI/LevelCompleteOverlay
@onready var level_failed_overlay: Control = $UI/LevelFailedOverlay
@onready var menu_background: Node = $MenuBackground
@onready var menu_background_content: Node = menu_background.get_child(0)
@onready var room_container: Node = $RoomContainer
@onready var music: FmodEventEmitter3D = $Music
@onready var music_transition: FmodEventEmitter2D = $Music_Transition

var debug: RefCounted

var room: Room

#var npcs: = []
#var max_tension: float = 0.0

func _ready() -> void:
	if OS.has_feature("debug") && FileAccess.file_exists("res://debug.gd"):
		var debug_script: GDScript = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	Harbinger.subscribe("prop_caught", prop_caught)
	main_menu.start_game.connect(on_start_game)

func _process(delta: float) -> void:
	DebugOverlay.display("fps %d" % Performance.get_monitor(Performance.TIME_FPS), null, true)
	#DebugOverlay.display({ tension = max_tension })

	if Input.is_action_just_pressed("menu"):
		back_to_menu()

#func _physics_process(delta: float) -> void:
	#max_tension = 0.0
	#for npc in npcs:
		#var tension: float = npc.get_node(^"BasicEmployee").detected * 2.0
		#if npc.state_machine.current_state == npc.state_machine.states["chasestate"]:
			#tension += 1.0
		#max_tension = max(tension, max_tension)

func on_start_game() -> void:
	main_menu.hide()
	menu_background.remove_child(menu_background_content)
	Harbinger.prune()
	room = room_scn.instantiate()
	room_container.add_child(room)
	room.prop_finished.connect(prop_finished)

	#for npc in room.get_node(^"Employees").find_children("", "CharacterBody3D", true, false):
		#npcs.append(npc)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	room.activate_next_prop()
	music_transition.play()

func back_to_menu() -> void:
	if level_complete_overlay.visible:
		return
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	room_container.remove_child(room)
	room.queue_free()
	#npcs.clear()
	get_tree().paused = false
	menu_background.add_child(menu_background_content)
	main_menu.show()

func prop_finished(name: String) -> void:
	get_tree().paused = true
	music.set_parameter("LEVELCOMPLETE", 1)
	level_complete_overlay.display(name)
	await level_complete_overlay.dismissed
	Harbinger.dispatch("npc_reset")
	room.activate_next_prop()
	music.set_parameter("LEVELCOMPLETE", 0)
	music.set_parameter("CHASE", 0)
	get_tree().paused = false

func prop_caught(params) -> void:
	var by: String = params[0]
	get_tree().paused = true
	level_failed_overlay.display(by)
	await level_failed_overlay.dismissed
	room.prop_order[room.prop_idx].reset()
	Harbinger.dispatch("npc_reset")
	music.set_parameter("CHASE", 0)
	get_tree().paused = false
