extends Node3D

const RAYCAST_VIS_SCN: PackedScene = preload("res://npc/RaycastVis.tscn")
const MOTION_SPEED_DEADZONE: float = 0.05

@export var vision_sensor: Node3D

@export_group("Detection", "detection_")
@export var detection_normal_profile: DetectionProfile
@export var detection_chase_profile: DetectionProfile
@export var detection_ray_length: float = 15.0
@export_range(0.0, 45.0, 0.5, "radians_as_degrees") var detection_ray_cone_angle: float = TAU / 32.0
@export_range(0, 4, 1) var detection_ray_cone_angle_steps: int = 3

@onready var num_rays: int = 1 + (detection_ray_cone_angle_steps * 6)
var raycast_vis: Array[RaycastVis]

var prop: Prop = null

var ray_idx: int = 0
var line_of_sight: bool = false
var los_last_ray_idx: int = 0
var los_distance: float = 0.0

var detection_profile: DetectionProfile
var detected: float = 0.0
var prop_last_pos: = Vector3.ZERO

func _ready() -> void:
	Harbinger.subscribe("active_prop", func(p): prop = p[0])
	for i in range(num_rays):
		var vis: = RAYCAST_VIS_SCN.instantiate()
		vision_sensor.add_child(vis)
		raycast_vis.append(vis)
	detection_profile = detection_normal_profile

func _process(delta: float) -> void:
	DebugOverlay.display({ los = line_of_sight, los_distance = los_distance, detected = detected, where = prop_last_pos }, self)
	if Input.is_action_just_pressed("debug_draw_raycast"):
		for vis in raycast_vis:
			vis.visible = !vis.visible

func _physics_process(delta: float) -> void:
	if !prop:
		detected = 0.0
		return

	#region perception
	var dir_to_prop: = (prop.global_position - vision_sensor.global_position).normalized()
	var dir: = dir_to_prop
	var cone_angle_axis: = dir.cross(dir.rotated(Vector3.UP, 0.5)).normalized()
	dir = dir.rotated(
		cone_angle_axis,
		((ray_idx + 5) / 6) * (detection_ray_cone_angle / detection_ray_cone_angle_steps)
	)
	dir = dir.rotated(
		dir_to_prop,
		((ray_idx + 5) % 6) * (TAU / 6.0)
	)

	var space_state: = get_world_3d().direct_space_state
	var query: = PhysicsRayQueryParameters3D.create(
		vision_sensor.global_position,
		vision_sensor.global_position + (dir * detection_ray_length)
	)
	var result: = space_state.intersect_ray(query)
	if result:
		if result.collider == prop:
			raycast_vis[ray_idx].update_vis(result.position, Color.GREEN)
			line_of_sight = true
			los_last_ray_idx = ray_idx
			prop_last_pos = result.position
			los_distance = (result.position - vision_sensor.global_position).length()
		else:
			raycast_vis[ray_idx].update_vis(result.position, Color.ORANGE)
			if los_last_ray_idx == ray_idx:
				line_of_sight = false
	else:
		raycast_vis[ray_idx].update_vis(vision_sensor.global_position + (dir * detection_ray_length), Color.DARK_RED)
		if los_last_ray_idx == ray_idx:
				line_of_sight = false

	ray_idx = (ray_idx + 1) % num_rays
	#endregion

	#region detection
	if line_of_sight:
		var prop_speed: = prop.velocity.length()
		if los_distance <= detection_profile.motion_range && prop_speed > MOTION_SPEED_DEADZONE:
			detected += prop_speed * detection_profile.motion_sensitivity * delta
		elif detection_profile != detection_chase_profile:
			detected -= detection_profile.decay * delta
	else:
		detected -= detection_profile.decay * delta

	detected = clampf(detected, 0.0, 1.0)
	#endregion

func use_normal_profile() -> void:
	detection_profile = detection_normal_profile

func use_chase_profile() -> void:
	detection_profile = detection_chase_profile
