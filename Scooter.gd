extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Scooter ready")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	set_applied_force(Vector2(0,0))
	set_applied_torque(0)
	
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
	
	# control steering lef/right
	var steer = Input.get_axis("move_left", "move_right")
	add_torque(steer*rotate_coefficient*forward_speed*delta)
	
	# steer anim
	var anim="default"
	if steer<0: 
		anim="left"
	elif steer>0: 
		anim="right"
	$AnimatedSprite.animation = anim
	
	# contol forward/backward/breaking
	var accelerate = Input.get_axis("move_back", "move_forward")
	if accelerate > 0: 
		add_force(Vector2(0,0),forward*forward_power*delta)
	elif accelerate < 0: 
		add_force(Vector2(0,0),-forward*reverse_power*delta)
	
	# control breaking
	var breaking = false
	if accelerate > 0: 
		if !roll_forwards and forward_velocity.length()>10:
			breaking = true
	elif accelerate < 0: 
		if roll_forwards and forward_velocity.length()>10:
			breaking = true	
		
	# friction and breaking
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

