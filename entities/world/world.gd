extends Node2D

export var map_size = 64;
export var tile_size = 20;

var player;
var camera;

func init(s, p, c):
	map_size = s;
	player = p;
	camera = c;

func _ready():
	var map = create_map(map_size);
	var center = (map_size * tile_size) / 2
	
	add_island(map, map_size / 4);
	add_texture(map, map_size);
	
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

func add_texture(map, size):
	for x in size:
		for y in size:
			var value = map[x][y];

			match value:
				0:
					$Nav/Water.set_cell(x, y, 0);
				1:
					$Nav/Grass.set_cell(x, y, 0);
		
	$Nav/Water.update_bitmask_region(Vector2(0, 0), Vector2(size, size));
	$Nav/Grass.update_bitmask_region(Vector2(0, 0), Vector2(size, size));

