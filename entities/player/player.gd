extends KinematicBody2D

var speed = 250
var velocity = Vector2()

func _physics_process(delta):
	velocity = get_direction_velocity(velocity, speed);
	move_and_collide(velocity * delta);

func get_direction_velocity(v: Vector2, s: int):
	v = Vector2();

	if Input.is_action_pressed('ui_right'):
		v.x += 1
	if Input.is_action_pressed('ui_left'):
		v.x -= 1
	if Input.is_action_pressed('ui_down'):
		v.y += 1
	if Input.is_action_pressed('ui_up'):
		v.y -= 1
	
	v = v.normalized() * s;
	
	return v;
