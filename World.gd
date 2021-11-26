extends Node2D

signal player_enter_pickup
signal player_exit_pickup

export var count_pickup_bodies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position = $PlayerStartPos.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
