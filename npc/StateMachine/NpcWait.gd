extends State
class_name NpcWait

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var parent: CharacterBody3D
var vy : float
var navigation_agent: NavigationAgent3D

@export var raycaster: Node3D

@export var wait_time : float
var remaining_time : float

func Enter():
	parent.velocity.x = 0
	parent.velocity.z = 0
	navigation_agent.set_target_position(parent.position)

func Physics_Update(delta):
	if !parent.is_on_floor():
		parent.velocity.y -= gravity * delta
		vy = parent.velocity.y


	if remaining_time > 0:
		remaining_time -=delta
		parent.velocity.x = 0
		parent.velocity.z = 0
		navigation_agent.set_target_position(parent.position)

	else:
		remaining_time = wait_time
		Transitioned.emit(self, "PatrolState")

	if raycaster.detected >= 0.9:
		Transitioned.emit(self, "ChaseState")
