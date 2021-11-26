extends Node2D

export var enable=true
export var position_velocity_newness = 0.9
export var angular_velocity_newness = 0.9
export var position_lookahead = 1.5
export var angular_lookahead = 0.5
export var position_offset_max = 256
export var angular_offset_max = 45


# -- state

# time averaged velocity
var position_velocity = Vector2(0,0)
var angular_velocity = 0
# previous frame pos and angle
var old_pos
var old_ang

# Called when the node enters the scene tree for the first time.
func _ready():
	var global  = self.get_global_transform()
	old_pos = global.get_origin()
	old_ang = global.get_rotation()
	
# every frame
func _process(delta):
	
	if !enable: return
	
	var global  = self.get_global_transform()
	var cur_pos = global.get_origin()
	var cur_ang = global.get_rotation()
	
	# difference with old pos and angle
	var position_diff = cur_pos - old_pos
	var angular_diff = cur_ang - old_ang
	if angular_diff > PI: angular_diff -= 2*PI
	if angular_diff < -PI: angular_diff += 2*PI
	
	#  time averaged velocity
	position_velocity = position_velocity * (1-(position_velocity_newness*delta)) + (position_diff/delta) * (position_velocity_newness * delta)
	angular_velocity = angular_velocity * (1-(angular_velocity_newness*delta)) + (angular_diff/delta) * (angular_velocity_newness * delta)
	
	# set camera pos based on velocity
	var position_offset = position_velocity * position_lookahead 
	if position_offset.length() > position_offset_max: 
		position_offset = position_offset / position_offset.length() * position_offset_max 
	var cam_pos = cur_pos + position_offset 
	
	var angular_offset = angular_velocity * angular_lookahead 
	if abs(angular_offset) > (angular_offset_max / 180 * PI): 
		angular_offset = angular_offset / abs(angular_offset) * (angular_offset_max / 180 * PI)
	var cam_ang = cur_ang + angular_offset
	
	# set viewport transform
	var vp = get_viewport()
	var center = vp.size / 2
	var transform = Transform2D(0,center)*Transform2D(-cam_ang,Vector2(0,0))*Transform2D(0,-cam_pos) 
	vp.canvas_transform = transform
	
	# update old pos (needed for velocity estimate)
	old_pos = cur_pos
	old_ang = cur_ang
	
