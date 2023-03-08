extends Node2D

func _ready():
	$Timer.connect("timeout", self, "update_paths");
	pass

func update_paths():
	get_tree().call_group('mob', 'update_path');
