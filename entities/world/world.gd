extends Node2D

export var map_size = 64;
export var tile_size = 20;

var player;
var camera;
var escape;

func init(s, p, c, e):
	map_size = s;
	player = p;
	camera = c;
	escape = e;

func _ready():
	var map = create_map(map_size);
	var center = (map_size * tile_size) / 2
	
	add_island(map, map_size / 4);
	add_wall(map, map_size);
	add_texture(map, map_size);
	
	if (escape):
		add_escape(map, escape);
	
	if (player):
		player.position = Vector2(center, center);
		
	if (camera):
		camera.position = Vector2(center, center);

func create_map(size):
	var map = [];

	for i in range(size):
		map.append([])
		for j in range(size):
			map[i].append(0)
			
	return map;


func add_island(map, size):
	var center_x = map.size() / 2 - 1;
	var center_y = map.size() / 2 - 1;
	var radius = size;

	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 0.5;
	noise.period = 20;

	for i in range(center_x - radius, center_x + radius):
		for j in range(center_y - radius, center_y + radius):
			var distance = sqrt(pow(i - center_x, 2) + pow(j - center_y, 2));
			
			if distance <= radius:
				map[i][j] = 1
				
				if noise.get_noise_2d(i, j) > 0.05 and distance > radius - radius / 2:
					map[i][j] = 0

	return map;
	

func get_island_border(map):
	var border = []

	for x in range(map.size()):
		for y in range(map[x].size()):
			if map[x][y] == 1:
				if map[x - 1][y] == 0 or map[x + 1][y] == 0 or map[x][y - 1] == 0 or map[x][y + 1] == 0:
					border.append(Vector2(x, y));

	return border;


func add_wall(map, size):
	var space_x = 3;
	var space_y = 10;
	var rng = RandomNumberGenerator.new();
	rng.randomize();
	
	for x in size:
		if (space_x > 0):
			space_x -= 1
			continue

		for y in size:
			if (map[x][y] != 1):
				continue
				
			if (space_y > 0):
				space_y -= 1
				continue
				
			if (rng.randf() < 0.50):
				var direction = rng.randi_range(0, 2)
				var wall_length = rng.randi_range(3, 20);
				var middle = wall_length / 2;
				
				if (direction == 0):
					for i in wall_length:
						if map[x + i][y] == 1:
							if (wall_length > 8 and i >= middle - 1 and i <= middle + 1):
								map[x + i][y] = 1;
								continue
							
							map[x + i][y] = 2;

				elif (direction == 1):
					for i in wall_length:
						if map[x][y + i] == 1:
							if (wall_length > 8 and i >= middle - 1 and i <= middle + 1):
								map[x + i][y] = 1;
								continue
								
							map[x][y + i] = 2;

			space_y = rng.randi_range(4, 10);
		space_x = rng.randi_range(4, 10);
	return map


func add_escape(map, escape):
	var rng = RandomNumberGenerator.new();
	var borders = get_island_border(map);
	
	rng.randomize();
	escape.position = borders[rng.randi_range(0, borders.size() - 1)] * tile_size;


func add_texture(map, size):
	for x in size:
		for y in size:
			var value = map[x][y];

			match value:
				0:
					$Nav/Water.set_cell(x, y, 0);
				1:
					$Nav/Grass.set_cell(x, y, 0);
				2: 
					$Nav/Wall.set_cell(x, y, 0);
		
	$Nav/Water.update_bitmask_region(Vector2(0, 0), Vector2(size, size));
	$Nav/Grass.update_bitmask_region(Vector2(0, 0), Vector2(size, size));
	$Nav/Wall.update_bitmask_region(Vector2(0, 0), Vector2(size, size));

