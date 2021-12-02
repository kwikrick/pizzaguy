extends Node2D

signal player_enter_pickup
signal player_exit_pickup

var Car = load("res://Car.tscn")
var Util = load("res://Util.gd")

export var count_pickup_bodies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position = $PlayerStartPos.position
	
# Called when the node enters the scene tree for the first time.
func _process(delta):
	pass
	#spawn_car_if_needed()
	
# ---- pickup area, pass on signal ---
# TODO: move pickup area to Main	

func _on_PickupArea_body_entered(body):
	#print("World: _on_PickupArea_body_entered")
	count_pickup_bodies +=1
	print("count_pickup_bodies=",count_pickup_bodies)
	if body==$Player:
		emit_signal("player_enter_pickup")
	


func _on_PickupArea_body_exited(body):
	#print("World: _on_PickupArea_body_exited")
	count_pickup_bodies -= 1
	print("count_pickup_bodies=",count_pickup_bodies)
	if body==$Player:
		emit_signal("player_exit_pickup")


# ---- Car spawning

func _on_CarSpawnArea_area_entered(area):
	#if a RoadDirectionMarker enters, spawn a car with some propabilty
	if area is RoadDirectionMarker:
		area.add_to_group("spawnmarkers")

func _on_CarSpawnArea_area_exited(area):
	if area is RoadDirectionMarker:
		area.remove_from_group("spawnmarkers")	

func _on_CarSpawnArea_body_exited(body):
	# if a Car leaves area, delete it
	if body is ClassCar:
		body.queue_free()
		# count cars
		#var cars = get_tree().get_nodes_in_group("cars")
		#print ("#cars=",cars.size())

func spawn_car_if_needed():
	var cars = get_tree().get_nodes_in_group("cars")
	print ("#cars=",cars.size())
	if cars.size() < 20:
		spawn_car()

func spawn_car():
	# shape to check collision
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(32,64)
	
	# find a spawnmarker that is in the spawnarea but off screen, and collision free
	var markers  = get_tree().get_nodes_in_group("spawnmarkers")
	var marker = null
	for i in range(markers.size()):
		var index = int(rand_range(0,markers.size()))
		var distance = (markers[index].get_global_position() - $Player.get_global_position()).length()
		if distance < 500: 
			continue  # TODO: use viewport
		if Util.test_shape_collides_bodies(get_world_2d(), shape, markers[index].get_global_transform(), 0xb1): 
			continue
		# found a good marker
		marker = markers[index]
	
	if marker!=null:
		var car = Car.instance()
		$Objects.add_child(car)
		car.add_to_group("cars")
		car.set_global_transform(marker.get_global_transform())
		


func _on_CarSpawnTimer_timeout():
	spawn_car_if_needed()

