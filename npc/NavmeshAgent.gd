extends CharacterBody3D

@export var navigation_agent : NavigationAgent3D
@export var route: Node

func _ready():
	find_child("State Machine",true,false).navigation_agent = navigation_agent
	find_child("State Machine",true,false).route = route
	pass

func _physics_process(delta):
	move_and_slide()

