extends Node2D

var Map = preload('res://entities/world/world.tscn');

func _ready():
	var map = Map.instance();
	
	map.init(200, $Player, $Camera, $Escape);
	add_child(map);
	move_child(map, 0);
	
	pass


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
