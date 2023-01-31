extends KinematicBody2D

export (NodePath) var control_path;
onready var control: ControlTouch = get_node(control_path);

var speed = 250;
var velocity = Vector2();

func _physics_process(delta):
	if control.left and control.left.is_pressed():
		position += get_position_touch(control.left.get_output(), speed, delta);
	#
	if move_keys_is_pressed():
		move_and_collide(get_direction_keys(velocity, speed, delta));
	
	if control.right and control.right.is_pressed():
		rotation = control.right.get_output().angle();

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

func move_keys_is_pressed():
	var right = Input.is_action_pressed('ui_right'); 
	var left = Input.is_action_pressed('ui_left');
	var down = Input.is_action_pressed('ui_down');
	var up = Input.is_action_pressed('ui_up');
	
	return right or left or down or up;
