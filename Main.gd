extends Control

# import scenes / classes to instance in code
const Util = preload("res://Util.gd")
const Car = preload("res://Car.tscn") 
const Trash = preload("res://Trash.tscn")

# Task states and current index
var task_states = ["Pickup pizza", "Please wait...", "Deliver pizza", "Wait here..."]
var task_state = 0

# distance to pickup determines time and money
var pickup_dist = 0

# game progress variables
var cash = 0
var chances = 3

# constants
# 8 city blocks of 5 buildings of 320 pixels
var city_size = 8*5*320

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main: _ready")
	# place pickup area (and start task timer)
	move_pickup()
	# spawn some cars
	for _i in range(100):
		spawn_car()
	# spawn some trash
	for _i in range(100):
		spawn_trash()
		
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# find player and target
	var player = $World/Player
	var target = $World/PickupArea
	var trans  = player.get_viewport_transform()
	var diff_vec = trans.xform(target.position) - trans.xform(player.position)
	var diff_ang = diff_vec.angle()

	# update compass
	var compass = $UICanvas/Compass
	compass.rotation = diff_ang
	
	# update task timer
	$UICanvas/TaskTimeBar.value = 100*$TaskTimer.time_left / $TaskTimer.wait_time 


func _on_World_player_enter_pickup():
	print("Main: _on_World_player_enter_pickup")
	$PickupTimer.start()
	# task (wait before pickup or wait before delivery)
	task_state=(task_state+1)%4
	$UICanvas/Panel/TaskDescription.text = task_states[task_state]
	
func _on_PickupTimer_timeout():
	print("Main: _on_PickupTimer_timeout")
	# cash on delivery
	if task_state==3:
		var tip = int(20*$TaskTimer.time_left / $TaskTimer.wait_time)
		cash+=tip
		$UICanvas/Panel2/Money.text = "Cash: $"+String(cash)
	# next task 
	task_state=(task_state+2)%4
	$UICanvas/Panel/TaskDescription.text = task_states[task_state]
	# move pickup area
	move_pickup()
	
func _on_World_player_exit_pickup():
	print("Main: _on_World_player_exit_pickup()")
	$PickupTimer.stop()
	# set task
	task_state=(task_state-1)%4
	$UICanvas/Panel/TaskDescription.text = task_states[task_state]
	
func _on_TaskTimer_timeout():
	print("Main: Task Failed")
	# fail
	chances-=1
	# show failed message
	if chances >0:
		$UICanvas/FailPanel/FailCount.text = "Chances left: "+String(chances)
		$UICanvas/FailPanel.visible = true
		$FailTimer.start()
		# new pickup task
		task_state=0
		$UICanvas/Panel/TaskDescription.text = task_states[task_state]
		# move area	
		move_pickup()
	else:
		$UICanvas/GameOverPanel.visible = true 
	
func _on_FailTimer_timeout():
	$UICanvas/FailPanel.visible = false

func _on_UICanvas_restart_game():
	print("Main._on_UICanvas_restart_game")
	# hide
	$UICanvas/GameOverPanel.visible = false
	# reset
	task_state = 0
	cash = 0
	chances = 3
	# update ui
	$UICanvas/Panel/TaskDescription.text = task_states[task_state]
	$UICanvas/Panel2/Money.text = "Cash: $"+String(cash)
	# set new pickup point
	move_pickup()
	

func move_pickup():
	print ("Main:move_pickup")
	Util.safe_random_jump_2d($World/PickupArea,$World/PickupArea/CollisionShape2D,Rect2(0,0,city_size,city_size))
	pickup_dist = ($World/PickupArea.position - $World/Player.position).length()
	# restart task timer
	$TaskTimer.wait_time = 10.0 + pickup_dist/200.0
	$TaskTimer.start()
	
func _on_SpawnTimer_timeout():
	# spawn some cars
	spawn_car()
	spawn_trash()
	
func spawn_car():
	var new_car = Car.instance()
	$World/Objects.add_child(new_car)
	Util.safe_random_jump_2d(new_car, new_car.get_node("CollisionShape2D"),Rect2(0,0,city_size,city_size))
#	
	
func spawn_trash():
	var new_trash = Trash.instance()
	$World/Objects.add_child(new_trash)
	Util.safe_random_jump_2d(new_trash, new_trash.get_node("CollisionShape2D"),Rect2(0,0,city_size,city_size))
