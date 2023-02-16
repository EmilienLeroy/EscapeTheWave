extends MarginContainer

var score = 0;

func init(data):
	score = data.score;

func _ready():
	$Container/Home.connect("button_down", self, "on_home_down");
	$Container/Restart.connect("button_down", self, "on_restart_down");
	$Container/Label.text = "Score:" + str(score);
	pass

func on_home_down():
	Router.goto_scene('res://scenes/home/home.tscn');
	
func on_restart_down():
	Router.goto_scene('res://scenes/single/single.tscn');
