extends Node2D

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

export var width = 40;
export var height = 40;
 
var start = Vector2(width / 4, height / 4);
var direction = Vector2.RIGHT
var borders = Rect2(0, 0, width, height)
var walls = [];
var walls_since_turn = 0;
var rooms = []

func _ready():
	walls.append(start);
	
	add_wall(walk(height * 10));
	add_grass();
	
	pass

func walk(steps):
	for step in steps:
		if walls_since_turn >= 8:
			change_direction()
		
		if step():
			walls.append(start)
		else:
			change_direction()
	return walls
	
func step():
	var target_position = start + direction
	if borders.has_point(target_position):
		walls_since_turn += 1
		start = target_position
		return true
	else:
		return false

func change_direction():
	walls_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(start + direction):
		direction = directions.pop_front()

func place_room(position):
	var size = Vector2(randi() % 4 + 2, randi() % 4 + 2)
	var top_left_corner = (position - size/2).ceil();
	
	rooms.append({position = position, size = size})
	
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				walls.append(new_step)

func add_grass():
	for x in width:
		for y in height: 
			$Grass.set_cell(x, y, 0);
			
	$Grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(width, height));


func add_wall(map):
	for location in map:
		$Wall.set_cellv(location, 0);

	$Wall.update_bitmask_region(Vector2(0.0, 0.0), Vector2(width, height));
