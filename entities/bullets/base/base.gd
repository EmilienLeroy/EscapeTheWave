extends Area2D

export var speed = 700;

func _physics_process(delta):
	position += transform.x * speed * delta
