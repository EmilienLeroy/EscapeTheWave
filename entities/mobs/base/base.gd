extends KinematicBody2D

export (NodePath) var nav_path;
export (NodePath) var player_path;
export var life = 30;
export var speed = 100;
export var score_value = 10;

var velocity = Vector2.ZERO;
var path = [];
var threshold = 16;
var nav = null;
var player = null;

func init(p: KinematicBody2D, n: Navigation2D):
	player = p;
	nav = n;
	
func _ready():
	if (nav_path):
		nav = get_node(nav_path);
	
	if (player_path):
		player = get_node(player_path);
	
	$Timer.connect("timeout", self, "on_timeout");
	
	set_life(life);

func _physics_process(delta):
	if path.size() > 0:
		move_to_target()

func move_to_target():
	if global_position.distance_to(path[0]) < threshold:
		path.remove(0)
	else:
		var direction = global_position.direction_to(path[0])
		velocity = direction * speed
		velocity = move_and_slide(velocity)
		
func get_target_path(target_pos):
	path = nav.get_simple_path(global_position, target_pos, false)

func damage(value: int):
	life = life - value;
	set_life(life);
	
	if (life <= 0):
		queue_free();
	
func set_life(life: int):
	$Life.text = str(life);

func on_timeout():
	if (!player):
		return;

	get_target_path(player.global_position);
