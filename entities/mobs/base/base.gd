extends KinematicBody2D

export var life = 30;

func _ready():
	set_life(life);

func damage(value: int):
	life = life - value;
	set_life(life);
	
	if (life <= 0):
		queue_free();
	
func set_life(life: int):
	$Life.text = str(life);
