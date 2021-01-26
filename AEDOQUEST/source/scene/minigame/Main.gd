extends Node2D

func _ready():
	$Button.connect("pressed", self, "game1")
	$Button2.connect("pressed", self, "game2")
func game1():
	get_tree().change_scene("res://source/scene/minigame/mg_keyslaying.tscn")

func game2():
	get_tree().change_scene("res://source/scene/minigame/time_guess.tscn")
