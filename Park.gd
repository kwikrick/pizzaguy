extends Node2D

var Util = preload("res://Util.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: collision detection not working?
	Util.safe_random_jump_2d($Tree1, $Tree1/CollisionShape2D, Rect2(32,32,256,256))
	Util.safe_random_jump_2d($Tree2, $Tree2/CollisionShape2D, Rect2(32,32,256,256))
	Util.safe_random_jump_2d($Tree3, $Tree3/CollisionShape2D, Rect2(32,32,256,256))
	Util.safe_random_jump_2d($Tree4, $Tree4/CollisionShape2D, Rect2(32,32,256,256))
	Util.safe_random_jump_2d($Tree5, $Tree5/CollisionShape2D, Rect2(32,32,256,256))
	Util.safe_random_jump_2d($Tree6, $Tree6/CollisionShape2D, Rect2(32,32,256,256))
	Util.safe_random_jump_2d($Tree7, $Tree7/CollisionShape2D, Rect2(32,32,256,256))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
