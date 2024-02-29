extends State
class_name NpcChase

signal chase_start
signal chase_end
signal lost_track

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var parent: CharacterBody3D
@export var speed : int = 3
var vy : float

@export var navigation_agent: NavigationAgent3D
@onready var last_position: Marker3D = $LastPos
@export var raycaster: Node3D

var next_path_position: Vector3
var current_agent_position: Vector3
var sfx_lost_track_played: bool = false

@onready var game: Game = find_parent("Game")

@onready var music = game.get_node("Music")

func _ready():
	self.is_inside_tree()
	set_physics_process(false)

	call_deferred("actor_setup")

	Harbinger.subscribe("npc_reset", reset)
	
	print(self.get_path())  # prints /root/Control/Node2D

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
	raycaster.use_chase_profile()
	music.set_parameter("CHASE", 3)

func Exit():
	chase_end.emit()

func Update(delta):
	DebugOverlay.display({ last_pos = last_position.global_position}, self)

func get_next_move(delta):
	navigation_agent.set_target_position(last_position.global_position)
	current_agent_position = parent.position
	next_path_position = navigation_agent.get_next_path_position()
	parent.velocity = current_agent_position.direction_to(next_path_position) * speed

func Physics_Update(delta):
	if !parent.is_on_floor():
		parent.velocity.y -= gravity * delta
		vy = parent.velocity.y

	if raycaster.line_of_sight:
		last_position.global_position = raycaster.prop_last_pos
		sfx_lost_track_played = false
	elif raycaster.detected < 0.1:
		#switch to idling
		Transitioned.emit(self, "PatrolState")
		#temp set movement to farts
		parent.velocity = Vector3.ZERO
		return

	get_next_move(delta)

	if (
		!sfx_lost_track_played
		&& navigation_agent.is_navigation_finished()
		&& !raycaster.line_of_sight
	):
		sfx_lost_track_played = true
		lost_track.emit()
		music.set_parameter("CHASE", 0)

	#rotation
	var to_next_path_pos_local: = parent.to_local(next_path_position)
	if to_next_path_pos_local.length_squared() > 0.25:
		var angle: = Vector3.FORWARD.signed_angle_to(to_next_path_pos_local, Vector3.UP)

		var slerp_rate: float = clamp(8.0 * (0.25 + 0.5 * (cos(angle) + 1.0)) * delta, 0.0, 1.0)
		var new_rotation_y: = lerp_angle(parent.rotation.y, parent.rotation.y + angle, slerp_rate)

		# prevent jitter/wiggle at low physics framerates
		if abs(angle_difference(parent.rotation.y, new_rotation_y)) > abs(angle):
			new_rotation_y = parent.rotation.y + angle

		parent.rotation.y = new_rotation_y

	parent.velocity.y = vy

func reset(_p) -> void:
	sfx_lost_track_played = false
