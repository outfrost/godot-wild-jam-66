class_name Room
extends Node3D

signal prop_finished(name: String)

@export var prop_order: Array[Prop]
@export var finish_area: Area3D

var prop_idx: int = -1

func _ready() -> void:
	assert(prop_order.size() > 0)
	finish_area.body_entered.connect(func(prop): prop_finished.emit(prop.friendlyname))

func activate_next_prop() -> void:
	if prop_idx >= 0:
		prop_order[prop_idx].deactivate()
	prop_idx += 1
	if prop_idx < prop_order.size():
		prop_order[prop_idx].activate()
		Harbinger.dispatch("active_prop", [prop_order[prop_idx]])
