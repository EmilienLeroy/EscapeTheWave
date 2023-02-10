extends Node2D

var score = 0;

func _ready():
	$Player.connect("increase_score", self, "on_increase_score");
	pass 

func on_increase_score(new_score: int):
	score = score + new_score;
	
	$HUD/Score.text = "Score: " + str(score);
