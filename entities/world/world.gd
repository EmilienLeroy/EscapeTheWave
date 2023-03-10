extends Node2D

var Spawn = preload("res://entities/mobs/spawn/spawn.tscn");
var Life = preload("res://entities/items/life/life.tscn");

export var map_size = 64;
export var tile_size = 20;

var player;
var camera;
var escape;
var spawn_number = 1;
var item_number = 1;

func init(s, p, c, e, n, i):
	map_size = s;
	player = p;
	camera = c;
	escape = e;
	spawn_number = n;
	item_number = i;

func _ready():
	var map = create_map(map_size);
	var center = (map_size * tile_size) / 2;
	
	add_island(map, (map_size / 2) - 2);
	remove_unconnected_island(map);
	add_wall(map, map_size);
	add_texture(map, map_size);
	add_items(map, item_number);
	VisualServer.set_default_clear_color(Color8(0, 119, 228));
	
	if (escape):
		add_escape(map, escape);
	
	if (player):
		player.position = Vector2(center, center);
		add_spawns(map, player, spawn_number);
		
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
				
				if noise.get_noise_2d(i, j) > 0.1 and distance > radius - radius / 2:
					map[i][j] = 0

	return map;
	

func get_island_border(map):
	var border = []
	var size = map.size();

	for x in range(size):
		for y in range(size):
			if x + 1 < size and y + 1 < size and map[x][y] == 1:
				if map[x - 1][y] == 0 or map[x + 1][y] == 0 or map[x][y - 1] == 0 or map[x][y + 1] == 0:
					border.append(Vector2(x, y));

	return border;

func remove_unconnected_island(map):
	var visited = [];
	
	for x in range(map.size()):
		visited.append([]);
		for y in range(map.size()):
			visited[x].append(false);

	var start = Vector2((map_size / 2) - 1, (map_size / 2) - 1);
	var stack = [start];

	while stack.size() > 0:
		var current = stack.pop_back();
		var x = current.x;
		var y = current.y;
		visited[x][y] = true;

		for i in range(x - 1, x + 2):
			for j in range(y - 1, y + 2):
				if i >= 0 and i < map.size() and j >= 0 and j < map.size() and map[i][j] == 1 and not visited[i][j]:
					stack.append(Vector2(i, j));

	for x in range(map.size()):
		for y in range(map.size()):
			if map[x][y] == 1 and not visited[x][y]:
				map[x][y] = 0;
				
	return map

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
						if x + i < size and map[x + i][y] == 1:
							if (wall_length > 8 and i >= middle - 1 and i <= middle + 1):
								map[x + i][y] = 1;
								continue
							
							map[x + i][y] = 2;

				elif (direction == 1):
					for i in wall_length:
						if x + i < size and y + i < size and map[x][y + i] == 1:
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

func add_spawns(map, player, number):
	var spawns = [];
	
	while spawns.size() < number:
		var x = randi() % map_size;
		var y = randi() % map_size;
		
		if (map[x][y] == 1):
			var spawn = Spawn.instance();
		
			spawn.init(player);
			spawn.position = Vector2(x * tile_size, y * tile_size);
			spawns.push_back(spawn);
			
			$Nav.add_child(spawn);
	
	return spawns;

func add_items(map, number):
	var items = [];
	
	while items.size() < number:
		var x = randi() % map_size;
		var y = randi() % map_size;
		
		if (map[x][y] == 1):
			# Currently only add life item
			# But in a futur version it must add a random item.
			var item = Life.instance();
		
			item.position = Vector2(x * tile_size, y * tile_size);
			items.push_back(item);
			
			add_child(item);
	
	return items;

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
