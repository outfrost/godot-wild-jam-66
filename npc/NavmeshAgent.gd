extends CharacterBody3D

@export var navigation_agent : NavigationAgent3D
@export var route : Node
@export var patrol_speed : float
@export var ping_pong_path : bool
@export var wait_time : float
@export var chase_speed : float

func _ready():
	find_child("State Machine",true,false).navigation_agent = navigation_agent
	find_child("State Machine",true,false).route = route
	find_child("State Machine",true,false).patrol_speed = patrol_speed
	find_child("State Machine",true,false).ping_pong_path = ping_pong_path
	find_child("State Machine",true,false).wait_time = wait_time
	find_child("State Machine",true,false).chase_speed = chase_speed
	pass

func _physics_process(delta):
	move_and_slide()
