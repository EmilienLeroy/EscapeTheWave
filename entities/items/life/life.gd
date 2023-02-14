extends Area2D

export var value = 10;

func _ready():
	connect("body_entered", self, "on_body_enter");
	pass;
	
func on_body_enter(body):
	if (!body.has_method('healing')):
		return;
	
	body.healing(value);
	queue_free();
