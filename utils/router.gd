extends Node

var current_scene = null;

func _ready():
	var root = get_tree().root;
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("update_current_view", path);

func update_current_view(path):
	var scene = ResourceLoader.load(path);
	
	current_scene.free();
	current_scene = scene.instance();
	get_tree().root.add_child(current_scene);
	get_tree().current_scene = current_scene;
