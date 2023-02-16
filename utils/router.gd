extends Node

var current_scene = null;

func _ready():
	var root = get_tree().root;
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path, data = null):
	call_deferred("update_current_view", path, data);

func update_current_view(path, data = null):
	var scene = ResourceLoader.load(path);
	
	current_scene.free();
	current_scene = scene.instance();
	
	if (current_scene.has_method('init')):
		current_scene.init(data);
	
	get_tree().root.add_child(current_scene);
	get_tree().current_scene = current_scene;
