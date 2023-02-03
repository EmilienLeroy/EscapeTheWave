extends Area2D

export var speed = 700;

func _ready():
	connect("body_entered", self, "on_body_enter");

func _physics_process(delta):
	position += transform.x * speed * delta

func on_body_enter(body):
	queue_free();
