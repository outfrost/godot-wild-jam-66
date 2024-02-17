extends State
class_name NpcWait

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var parent: CharacterBody3D
var vy : float
var navigation_agent: NavigationAgent3D

@export var wait_time : float
var remaining_time : float

func Physics_Update(delta):
	if !parent.is_on_floor():
		parent.velocity.y -= gravity * delta
		vy = parent.velocity.y
	parent.velocity.y = vy

	if remaining_time > 0:
		remaining_time -=delta

	else:
		remaining_time = wait_time
		Transitioned.emit(self, "PatrolState")
		#switch state
