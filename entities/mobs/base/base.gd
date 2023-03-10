extends KinematicBody2D

const MIN_TIME_UPDATE_PATH = 1000;

onready var agent = $NavigationAgent2D;

export (NodePath) var player_path;
export var life = 30;
export var speed = 100;
export var score_value = 10;
export var attack_interval = 10;
export var damage = 10;

var velocity = Vector2();
var threshold = 16;
var nav = null;
var player = null;
var last_stamp = -1

func init(p: KinematicBody2D):
	player = p;
	
	if (player):
		player.connect('game_over', self, 'on_game_over');
	
func _ready():
	if (player_path):
		player = get_node(player_path);
		player.connect('game_over', self, 'on_game_over');
	
	set_life(life);
	
	velocity = Vector2(rand_range(-100, 100), rand_range(-100, 100));
	agent.call_deferred('set_target_location', player.global_position);


func _process(delta):
	var is_attack_frame = Engine.get_idle_frames() % attack_interval == 0;
	
	if (is_attack_frame):
		attack_players();
		
	if ($VisibilityNotifier2D.is_on_screen()):
		var target_global_position = agent.get_next_location();
		var direction = global_position.direction_to(target_global_position);
		var desired_velocity = direction * agent.max_speed;
		var steering = (desired_velocity - velocity) * delta * 4.0;
		
		velocity += steering;
		agent.call_deferred('set_velocity', velocity);
		
	move_and_slide(velocity);

func attack_players():
	var bodies = $Attack.get_overlapping_bodies();
	
	for body in bodies:
		if (!body.is_in_group('mob') && body.has_method('take_damage')):
			body.take_damage(damage);

func take_damage(value: int):
	life = life - value;
	set_life(life);
	
	if (life <= 0):
		queue_free();
	
func set_life(life: int):
	$Life.text = str(life);

func update_path():
	if (!player):
		return;

	var curr_stamp = OS.get_system_time_msecs();

	if last_stamp < 0:
		last_stamp = curr_stamp;

	if (curr_stamp - last_stamp) >= MIN_TIME_UPDATE_PATH:
		agent.call_deferred('set_target_location', player.global_position);

func on_game_over(score):
	player = null;
