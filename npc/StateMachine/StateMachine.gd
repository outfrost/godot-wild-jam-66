extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}




var navigation_agent: NavigationAgent3D

func  _ready():
	late_ready()

func late_ready():
	await get_tree().physics_frame

	# code is paused here until you call late_ready

	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			late_ready()
			child.navigation_agent = navigation_agent
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return

	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()

	current_state = new_state
