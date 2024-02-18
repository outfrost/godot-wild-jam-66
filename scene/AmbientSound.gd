extends Node

const FADE_DIST: float = 5.0
const MAX_VOLUME: float = 2.0

class SoundArea:
	var aabb: AABB
	var sound: FmodEventEmitter3D

	func _init(aabb: AABB, sound: FmodEventEmitter3D) -> void:
		self.aabb = aabb
		self.sound = sound

var areas: Array[SoundArea] = []

func _ready() -> void:
	#for child in get_children():
		#var col: = child as CollisionShape3D
		#var shape: = child.shape as BoxShape3D
		#var aabb: = AABB(col.global_position - shape.size / 2.0, shape.size)
		#areas.append(SoundArea.new(aabb, col.get_node("Sound")))
	pass

func set_listener_pos(global_pos: Vector3) -> void:
	#for area in areas:
		#var dist: = aabb_distance(area.aabb, global_pos)
		#area.sound.volume = smoothstep(FADE_DIST, 0.0, dist) * MAX_VOLUME
	pass

func aabb_distance(aabb: AABB, point: Vector3) -> float:
	return point.distance_to(point.clamp(aabb.position, aabb.end))
