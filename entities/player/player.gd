extends KinematicBody2D

signal increase_score;
signal game_over;

var Bullet = preload("res://entities/bullets/base/base.tscn");

export (NodePath) var control_path;
onready var control: ControlTouch = get_node(control_path);

export var speed = 250;
export var life = 100;
export var max_life = 100;
export var shoot_interval = 10;

var velocity = Vector2();

func _ready():
	set_life(life);

func _physics_process(delta):
	if control.left and control.left.is_pressed():
		move_and_slide(get_direction_touch(control.left.get_output(), speed, 1));

	if move_keys_is_pressed():
		move_and_slide(get_direction_keys(velocity, speed, 1));
	
	if control.right and control.right.is_pressed():
		rotation = control.right.get_output().angle();
		
	if !OS.has_touchscreen_ui_hint():
		look_at(get_global_mouse_position());
		
func _process(delta):
	var is_shoot_frame = Engine.get_idle_frames() % shoot_interval == 0;
	var is_mouse_pressed = Input.is_mouse_button_pressed(BUTTON_LEFT) and !OS.has_touchscreen_ui_hint();
	var is_touch_pressed = control.right and control.right.is_pressed();
	
	if (is_shoot_frame and (is_mouse_pressed or is_touch_pressed)):
		shoot();

func get_direction_touch(v: Vector2, s: int, d: float):
	return v.normalized() * s * d;

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

func shoot():
	var bullet = Bullet.instance();
	
	owner.add_child(bullet);
	bullet.transform = $Muzzle.global_transform;
	bullet.connect("kill_mob", self, "on_mob_kill");

func take_damage(value: int):
	life = life - value;
	set_life(life);
	
	if (life <= 0):
		emit_signal('game_over');
		queue_free();

func healing(value: int):
	var new_life = life + value;
	
	if (max_life < new_life):
		return;
	
	life = new_life;
	set_life(life);

func set_life(life: int):
	$Life.text = str(life);

func on_mob_kill(mob):
	emit_signal("increase_score", mob.score_value);

