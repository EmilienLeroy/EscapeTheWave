extends Position2D

var Mob = preload("res://entities/mobs/base/base.tscn");

export (NodePath) var nav_path;
export (NodePath) var player_path;

var nav = null;
var player = null;
var rng = RandomNumberGenerator.new();
var max_mobs = ProjectSettings.get_setting('global/max_mobs');

func _ready():
	rng.randomize();
	nav = get_node(nav_path);
	player = get_node(player_path);
	
	$Timer.connect("timeout", self, "on_timeout");
	pass

func create_mob():
	var mob = Mob.instance();
	
	mob.init(player, nav);
	return mob;

func on_timeout():
	$Timer.wait_time = rng.randi_range(1, 5);
	
	if (max_mobs <= get_tree().get_nodes_in_group("mob").size()):
		return;
	
	var mob = create_mob();
	add_child(mob);
	mob.global_position = global_position;
	
