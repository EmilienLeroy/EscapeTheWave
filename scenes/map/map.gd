extends Node2D

var Map = preload('res://entities/world/world.tscn');

var score = 0;
var level = 1;
var map_size = 40;

func init(data):
	level = data.level;
	score = data.score;

func _ready():
	var map = Map.instance();
	
	map.init(map_size * level, $Player, $Camera, $Escape, level);
	add_child(map);
	move_child(map, 0);
	
	$Player.score = score;
	$Player.connect("update_score", self, "on_score_updated");
	$Escape.connect("player_escape", self, "on_player_escape");
	$HUD/Level.text = 'Level: ' + str(level);
	$HUD/Score.text = 'Score: ' + str(score);
	
	pass

func on_score_updated(update_score):
	$HUD/Score.text = 'Score: ' + str(update_score);

func on_player_escape(escape_score):
	Router.goto_scene('res://scenes/map/map.tscn', {
		"level": level + 1,
		"score": escape_score
	});

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# debug function to regenerate the current level
		Router.goto_scene('res://scenes/map/map.tscn', {
			"level": level,
			"score": score
		});
