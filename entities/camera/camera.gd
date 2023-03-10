extends Camera2D

export (NodePath) var target_path;
var target;

func _ready():
	target = get_node(target_path);
	
	if (target):
		position = target.position;
		target.connect("game_over", self, "on_game_over");

func _physics_process(delta):
	if (!target):
		return;

	position = lerp(position, target.position, 0.08);

func on_game_over(score):
	target = null;
