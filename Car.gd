extends RigidBody2D

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass

# ------- physics -----

func _physics_process(delta):

	# reset force/torque
	set_applied_force(Vector2(0,0))
	set_applied_torque(0)
	
	# power/steering parameters
	var forward_power = 1e4
	var rotate_coefficient = 1e3
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
	
	# contol forward/backward/breaking
	var breaking = false
#	if Input.is_action_pressed("ui_up"): 
#		if !roll_forwards and forward_velocity.length()>10:
#			breaking = true
#		add_force(Vector2(0,0),forward*forward_power*delta)
#	if Input.is_action_pressed("ui_down"): 
#		if roll_forwards and forward_velocity.length()>10:
#			breaking = true	
#		add_force(Vector2(0,0),-forward*reverse_power*delta)
#
#	# control lef/right
#	###var anim="default"
#	if Input.is_action_pressed("ui_right"): 
#		add_torque(forward_speed*rotate_coefficient*delta)
#		###anim="right"
#	if Input.is_action_pressed("ui_left"): 
#		add_torque(-forward_speed*rotate_coefficient*delta)
#		##anim="left" 

	###$AnimatedSprite.animation = anim
	
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
		
