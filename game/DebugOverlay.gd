extends Node

@onready var label: Label = $DebugLabel
@onready var release_mode: bool = !OS.has_feature("debug")

var buffer: String = ""

func _ready():
	label.text = ""

func _process(_delta):
	label.text = buffer
	buffer = ""

func display(expr, caller: Node = null, show_in_release: bool = false):
	if release_mode && !show_in_release:
		return
	if caller:
		buffer += "[%s] " % caller.name
	buffer += str(expr) + "\n"
