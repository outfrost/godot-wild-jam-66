extends State
class_name NpcChase

signal chase_start
signal chase_end

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var parent: CharacterBody3D
@export var speed : int = 3
var vy : float

@export var navigation_agent: NavigationAgent3D
@onready var last_position: Marker3D = $LastPos
@export var raycaster: Node3D

var next_path_position: Vector3
var current_agent_position: Vector3

func _ready():
	set_physics_process(false)

	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	set_physics_process(true)

func Enter():
	chase_start.emit()
	parent.velocity.x = 0
	parent.velocity.z = 0
	last_position.global_position = raycaster.prop_last_pos
	navigation_agent.set_target_position(last_position.global_position)

func Exit():
	chase_end.emit()

func Update(delta):
	DebugOverlay.display({ last_pos = last_position.global_position}, self)

func get_next_move(delta):
	if navigation_agent.is_navigation_finished():
		navigation_agent.set_target_position(last_position.global_position)
	current_agent_position = parent.position
	next_path_position = navigation_agent.get_next_path_position()
	parent.velocity = current_agent_position.direction_to(next_path_position) * speed

func Physics_Update(delta):
	if !parent.is_on_floor():
		parent.velocity.y -= gravity * delta
		vy = parent.velocity.y


	if raycaster.detected > 0.1:
		#we still have some suspiicion, go to last player location
		last_position.global_position = raycaster.prop_last_pos
		get_next_move(delta)
	else:
		#switch to idling
		Transitioned.emit(self, "PatrolState")
		#temp set movement to farts
		parent.velocity = Vector3.ZERO

	#rotation
	if (parent.position - next_path_position).length() > 0.5:
		parent.look_at(next_path_position,Vector3.UP)



	parent.velocity.y = vy
