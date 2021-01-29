extends Control

func _ready():
	$Button.connect("pressed", self,"recom")
	pass
	
func recom():
	get_tree().change_scene("res://source/scene/Menus/Main.tscn")
