extends RigidBody2D

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

# ------ sensors ----
var front_area = 0
var left_area = 0
var right_area = 0


# ------- physics -----

func _physics_process(delta):

	# reset force/torque
	set_applied_force(Vector2(0,0))
	set_applied_torque(0)
	
	# power/steering parameters
	var forward_power = 1e4
	var rotate_coefficient = 5e3
	var reverse_power = 5e3
	
	# get and compute some directions and velocities
	var angle = get_global_rotation();
	var forward = Vector2(0,-1).rotated(angle)
	var right = Vector2(1,0).rotated(angle)
	var linear_velocity = get_linear_velocity()
	var angular_velocity = get_angular_velocity()
	var forward_velocity = linear_velocity.project(forward)
	var right_velocity = linear_velocity.project(right)
	var roll_forwards = linear_velocity.dot(forward) > 0
	var forward_speed = forward_velocity.length()
	if !roll_forwards: forward_speed *= -1
	
	# ai control
	var press_up=false
	var press_down=false
	var press_left=false
	var press_right=false
	
	if front_area > 0:
		press_down=true
	else:
		press_up=true
	
	if left_area > 0:
		if roll_forwards:
			press_right=true
		else:
			press_left=true
		
	if right_area > 0:
		if roll_forwards:
			press_left=true
		else:
			press_right=true
	
	# contol forward/backward/breaking
	var breaking = false
	if press_up: 
		if !roll_forwards and forward_velocity.length()>10:
			breaking = true
		add_force(Vector2(0,0),forward*forward_power*delta)
	if press_down: 
		if roll_forwards and forward_velocity.length()>10:
			breaking = true	
		add_force(Vector2(0,0),-forward*reverse_power*delta)

	# control lef/right
	if press_right: 
		add_torque(forward_speed*rotate_coefficient*delta)
	if press_left: 
		add_torque(-forward_speed*rotate_coefficient*delta)
	
	# friction (and breaking)
	var roll_friction_coeefficient = 10
	if breaking:
		roll_friction_coeefficient = 100

	var slide_friction_coeefficient = 300
	var angular_friction_coeefficient = 1e5
	
	var angular_friction_torque = -angular_velocity * angular_friction_coeefficient * delta
	var forward_friction_force = -forward_velocity * roll_friction_coeefficient * delta
	var right_friction_force = -right_velocity * slide_friction_coeefficient * delta
	
	add_force(Vector2(0,0),forward_friction_force)
	add_force(Vector2(0,0),right_friction_force)
	add_torque(angular_friction_torque)
		


func _on_FrontArea_body_entered(body):
	front_area+=1

func _on_FrontArea_body_exited(body):
	front_area-=1

func _on_LeftArea_body_entered(body):
	left_area+=1

func _on_LeftArea_body_exited(body):
	left_area-=1

func _on_RightArea_body_entered(body):
	right_area+=1

func _on_RightArea_body_exited(body):
	right_area-=1

