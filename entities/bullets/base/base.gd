extends Area2D

signal kill_mob;

export var speed = 700;
export var damage = 10;

func _ready():
	connect("body_entered", self, "on_body_enter");

func _physics_process(delta):
	position += transform.x * speed * delta

func on_body_enter(body):
	if (body.is_in_group('mob') and body.has_method('take_damage')):
		body.take_damage(damage);
	
		if (body.life <= 0):
			emit_signal("kill_mob", body);
	
	queue_free();
