extends Area2D

class_name RoadArea

var marker: RoadDirectionMarker 

# Called when the node enters the scene tree for the first time.
func _ready():
	# find road direction marker
	var nodes = get_children()
	for node in nodes:
		if node is RoadDirectionMarker:
			marker = node
	assert(marker)
	
