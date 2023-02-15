extends MarginContainer


func _ready():
	$Box/Button.connect("button_down", self, "on_button_down")
	pass 

func on_button_down():
	Router.goto_scene("res://scenes/single/single.tscn");
