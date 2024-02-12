extends CharacterBody3D

const RAYCAST_VIS_SCN: PackedScene = preload("res://npc/RaycastVis.tscn")

@export var vision_sensor: Node3D

@export_group("Detection", "detection_")
@export_subgroup("Normal Range", "detection_normal_range_")
@export var detection_normal_range_movement: = 8.0
@export var detection_normal_range_environment: = 6.0
@export_subgroup("Chase Range", "detection_chase_range_")
@export var detection_chase_range_movement: = 14.0
@export var detection_chase_range_environment: = 10.0
@export var detection_ray_length: float = 15.0
@export_range(0.0, 45.0, 0.5, "radians_as_degrees") var detection_ray_cone_angle: float = TAU / 32.0
@export_range(0, 4, 1) var detection_ray_cone_angle_steps: int = 3

@onready var num_rays: int = 1 + (detection_ray_cone_angle_steps * 6)
var raycast_vis: Array[RaycastVis]

var prop: Node3D = null
var ray_idx: int = 0

func _ready() -> void:
	Harbinger.subscribe("active_prop", func(p): prop = p[0])
	for i in range(num_rays):
		var vis: = RAYCAST_VIS_SCN.instantiate()
		vision_sensor.add_child(vis)
		raycast_vis.append(vis)

func _process(delta: float) -> void:
	DebugOverlay.display(prop, self)

func _physics_process(delta: float) -> void:
	if !prop:
		return

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
		else:
			raycast_vis[ray_idx].update_vis(result.position, Color.ORANGE)
		#raycast_vis.show()
	else:
		raycast_vis[ray_idx].update_vis(vision_sensor.global_position + (dir * detection_ray_length), Color.DARK_RED)
		#raycast_vis.hide()

	ray_idx = (ray_idx + 1) % num_rays
