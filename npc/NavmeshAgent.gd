extends CharacterBody3D

@export var navigation_agent : NavigationAgent3D

func _ready():
	find_child("State Machine",true,false).navigation_agent = navigation_agent
	pass

func _physics_process(delta):
	move_and_slide()

