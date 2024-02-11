extends Node

@onready var label: Label = $DebugLabel

var buffer: String = ""

func _ready():
	label.text = ""

func _process(_delta):
	label.text = buffer
	buffer = ""

func display(s, caller: Node = null):
	if caller is Node:
		buffer += "[%s] " % caller.name
	buffer += str(s) + "\n"
