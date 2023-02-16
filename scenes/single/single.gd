extends Node2D

var score = 0;

func _ready():
	$Player.connect("update_score", self, "on_increase_score");
	$Player.connect("game_over", self, "on_game_over");
	pass 

func on_increase_score(new_score: int):
	score = new_score;
	$HUD/Score.text = "Score: " + str(score);

func on_game_over(end_score: int):
	yield(get_tree().create_timer(0.5), "timeout");
	
	Router.goto_scene('res://scenes/score/score.tscn', {
		"score": end_score
	});
