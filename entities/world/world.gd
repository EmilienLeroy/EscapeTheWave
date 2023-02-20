extends Node2D


export var width = 40;
export var height = 40;

var noise;

func _ready():
	var noise = OpenSimplexNoise.new();

	noise.seed = randi();
	noise.octaves = 1.0;
	noise.period = 20;
	
	add_wall(noise);
	add_grass();
	
	pass

func add_grass():
	for x in width:
		for y in height: 
			$Grass.set_cell(x, y, 0);
			
	$Grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(width, height));


func add_wall(noise):
	for x in width:
		for y in height: 
			var a = noise.get_noise_2d(x, y)
			if a < 0.3 and a > 0.05:
				$Wall.set_cell(x, y, 0);
	
	$Wall.update_bitmask_region(Vector2(0.0, 0.0), Vector2(width, height));
