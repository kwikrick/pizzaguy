extends RigidBody2D

class_name ClassCar

# ------- physics -----

func _physics_process(delta):

	# reset force/torque
	set_applied_force(Vector2(0,0))
	set_applied_torque(0)
	
	# power/steering parameters
	var forward_power = 1e4
	var rotate_coefficient = 1e4
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
	
	# avoid collisions
	if $FrontCollisionSensor.count > 0:
		press_down=true
	else:
		press_up=true
	
	if $LeftCollisionSensor.count > 0:
		if roll_forwards:
			press_right=true
		else:
			press_left=true
		
	if $RightCollisionSensor.count > 0:
		if roll_forwards:
			press_left=true
		else:
			press_right=true
			
	# stay in road boundaries
	if $RightRoadSensor.road && !$LeftRoadSensor.road:
		if roll_forwards:
			press_right=true
		
	if $LeftRoadSensor.road && !$RightRoadSensor.road:
		if roll_forwards:
			press_left=true
	
	# follow road		
	if $FrontRoadSensor.road:
		var rel_rotation = $FrontRoadSensor.road.marker.global_rotation - self.global_rotation
		if rel_rotation > PI:
			rel_rotation-=2*PI
		if rel_rotation < -PI:
			rel_rotation+=2*PI
		#print ("rel_rotation ",rel_rotation)
		if rel_rotation > PI/16:
			press_right=true;
		if rel_rotation < -PI/16:
			press_left=true;
				
			
			
	
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

	var slide_friction_coeefficient = 1000
	var angular_friction_coeefficient = 5e5
	
	var angular_friction_torque = -angular_velocity * angular_friction_coeefficient * delta
	var forward_friction_force = -forward_velocity * roll_friction_coeefficient * delta
	var right_friction_force = -right_velocity * slide_friction_coeefficient * delta
	
	add_force(Vector2(0,0),forward_friction_force)
	add_force(Vector2(0,0),right_friction_force)
	add_torque(angular_friction_torque)
		

