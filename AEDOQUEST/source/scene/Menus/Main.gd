extends Control

func _ready():
	$NewGame.connect("pressed", self, "newgame")
	$Quit.connect("pressed", self, "quit")
func newgame():
	get_tree().change_scene("res://source/scene/mapa/mapa_1.tscn")

func quit():
	get_tree().quit()
