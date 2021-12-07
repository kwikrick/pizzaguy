extends Area2D

# Declare member variables here. Examples:
var count=0

func _on_CollisionSensor_body_entered(body):
	count+=1

func _on_CollisionSensor_body_exited(body):
	count-=1
