extends KinematicBody2D

export (NodePath) var joystick_left_path;
onready var left : VirtualJoystick = get_node(joystick_left_path)

var speed = 250;
var velocity = Vector2();

func _physics_process(delta):
	if left and left.is_pressed():
		position += get_position_touch(left.get_output(), speed, delta);
	else:
		move_and_collide(get_direction_keys(velocity, speed, delta));

func get_position_touch(v: Vector2, s: int, d: float):
	return v * s * d;

func get_direction_keys(v: Vector2, s: int, d: float):
	v = Vector2();

	if Input.is_action_pressed('ui_right'):
		v.x += 1
	if Input.is_action_pressed('ui_left'):
		v.x -= 1
	if Input.is_action_pressed('ui_down'):
		v.y += 1
	if Input.is_action_pressed('ui_up'):
		v.y -= 1
	
	return  v.normalized() * s * d;
