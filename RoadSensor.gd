extends Area2D


var areas=Dictionary()
var road: RoadArea = null

func _on_RoadSensor_area_entered(area):
	if area is RoadArea:
		areas[area]=1
		if !road:
			find_suitable_road()
			
func _on_RoadSensor_area_exited(area):
	if area is RoadArea:
		areas.erase(area)
		# if lost current road, find a different one
		if area == road:
			road = null
			#Debug
			#$LED.visible = false
			find_suitable_road()

func find_suitable_road():
	for area in areas:
		var rel_rotation = area.marker.global_rotation - self.global_rotation
		if rel_rotation > PI:
			rel_rotation-=2*PI
		if rel_rotation < -PI:
			rel_rotation+=2*PI
		#print ("rel_rotation ",rel_rotation)
		if abs(rel_rotation) < PI/2:
			road=area
			#Debug
			#$LED.visible=true
