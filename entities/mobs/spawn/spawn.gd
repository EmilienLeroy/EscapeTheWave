extends Position2D

var Mob = preload("res://entities/mobs/base/base.tscn");

export (NodePath) var nav_path;
export (NodePath) var player_path;

var nav = null;
var player = null;
var rng = RandomNumberGenerator.new();
var max_mobs = ProjectSettings.get_setting('global/max_mobs');


func init(p, n):
	player = p;
	nav = n;
	
	player.connect('game_over', self, "on_game_over");

func _ready():
	rng.randomize();
	
	if (nav_path):
		nav = get_node(nav_path);
	
	if (player_path):
		player = get_node(player_path);
		player.connect('game_over', self, "on_game_over");

	$Timer.connect("timeout", self, "on_timeout");
	pass

func create_mob():
	var mob = Mob.instance();
	
	mob.init(player, nav);
	return mob;

func on_timeout():
	$Timer.wait_time = rng.randi_range(1, 5);
	
	if (!player or max_mobs <= get_tree().get_nodes_in_group("mob").size()):
		return;
	
	var mob = create_mob();
	add_child(mob);
	mob.global_position = global_position;
	
func on_game_over(score):
	player = null;
