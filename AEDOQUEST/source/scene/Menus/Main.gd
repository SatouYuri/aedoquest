extends Control

func _ready():
	$NewGame.connect("pressed", self, "newgame")
	$AnimationPlayer.play("start")
func newgame():
	$AnimationPlayer.play("fadeout")
	
func start():
	get_tree().change_scene("res://source/scene/mapa/mapa_1.tscn")
