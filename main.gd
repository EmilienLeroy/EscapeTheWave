extends Node2D


func _ready():
	randomize();
	
	Engine.set_target_fps(60);
	Router.goto_scene('res://scenes/home/home.tscn');
	pass

