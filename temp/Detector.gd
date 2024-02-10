extends StaticBody3D

var left = true
@export var speed = 3.0
@export var ray_length = 30.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !left:
		translate(Vector3(delta * speed, 0.0, 0.0))
		if position.x >= 15:
			left = true
	else:
		translate(Vector3(-delta * speed, 0.0, 0.0))
		if position.x <= -15:
			left = false

func _physics_process(delta):
	#use global coords pls
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(position,Vector3(position.x,position.y,position.z+20))
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	
	if result:
		#print("hit at " , result.position)
		#print("hit at " + str(result.position))
		print("hit at %v" % result.position)
	
	var ray = RayCast3D
	pass
