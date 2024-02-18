extends CharacterBody3D

@export var navigation_agent : NavigationAgent3D
@export var route : Node
@export var patrol_speed : float
@export var ping_pong_path : bool
@export var wait_time : float
@export var chase_speed : float

var state_machine

func _ready():
	state_machine = find_child("State Machine",true,false)
	state_machine.navigation_agent = navigation_agent
	state_machine.route = route
	state_machine.patrol_speed = patrol_speed
	state_machine.ping_pong_path = ping_pong_path
	state_machine.wait_time = wait_time
	state_machine.chase_speed = chase_speed

	$CatchArea.body_entered.connect(func(body):
		if body is Prop && state_machine.current_state == state_machine.states["chasestate"]:
			Harbinger.dispatch("prop_caught", [self.name])
	)

func _physics_process(delta):
	move_and_slide()
