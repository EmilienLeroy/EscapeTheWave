extends Area2D

signal player_escape;

func _ready():
	connect("body_entered", self, "on_body_entered")
	pass

func on_body_entered(body):
	if (!body.is_in_group("player")):
		return;
	
	emit_signal('player_escape', body.score);
	
