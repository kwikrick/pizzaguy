extends Node

# let new_node jump to a random position in rect

static func safe_random_jump_2d(new_node:CollisionObject2D, shape:CollisionShape2D, rect, max_try=100):
		var i=0
		while i<max_try:
			i+=1
			var x = rand_range(rect.position.x ,rect.end.x)
			var y = rand_range(rect.position.y ,rect.end.y)
			var a = rand_range(0,360)
			var transform = Transform2D(a/180.0*PI,Vector2(x,y))
		
			var space = new_node.get_world_2d().get_space()
			var space_state = Physics2DServer.space_get_direct_state(space)		
			
			var query = ClassDB.instance("Physics2DShapeQueryParameters")
			query.set_shape(shape.shape)
			query.collision_layer = new_node.collision_layer
			query.transform = transform
			query.collide_with_bodies = true
			query.collide_with_areas = false

			var collisions = space_state.intersect_shape(query)
			var count = collisions.size()
			if count==0: 
				new_node.transform = transform
				#print("safe_random_jump_2d: sucess ",new_node) 
				break
		
		if i>max_try:
			print("safe_random_jump_2d: failed", new_node) 
			


static func check_node_shape_collision_free(new_node:CollisionObject2D, shape:CollisionShape2D):

	var space = new_node.get_world_2d().get_space()
	var space_state = Physics2DServer.space_get_direct_state(space)		
	
	var query = ClassDB.instance("Physics2DShapeQueryParameters")
	query.set_shape(shape.shape)
	query.collision_layer = new_node.collision_layer
	query.transform = new_node.transform
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var collisions = space_state.intersect_shape(query)
	var count = collisions.size()
	return count==0
	
static func test_shape_collides_bodies(world:World2D, shape:Shape2D, transform:Transform2D, collision_layer:int):

	var space = world.get_space()
	var space_state = Physics2DServer.space_get_direct_state(space)		
	
	var query = ClassDB.instance("Physics2DShapeQueryParameters")
	query.set_shape(shape)
	query.collision_layer = collision_layer
	query.transform = transform
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var collisions = space_state.intersect_shape(query)
	var count = collisions.size()
	return (count>0)
