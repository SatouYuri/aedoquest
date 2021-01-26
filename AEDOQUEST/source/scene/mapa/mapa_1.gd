extends Node2D

var on_door_1 = false
var on_door_2 = false
var on_npc = false
var on_enemy = false

var door_locked = true

var current_minigame_index = -1 
var game

var minigame_list = [load("res://source/scene/minigame/mg_keyslaying.tscn"),
					load("res://source/scene/minigame/time_guess.tscn")]
func _ready():
	$CanvasLayer/Left.connect("button_down", $Player,"press_left")
	$CanvasLayer/Left.connect("button_up", $Player,"unpress_left")
	$CanvasLayer/Right.connect("button_down", $Player,"press_right")
	$CanvasLayer/Right.connect("button_up", $Player,"unpress_right")
	$NPC.connect("body_entered",self,"body_close_npc")
	$NPC.connect("body_exited",self,"body_leave_npc")
	$Torre.connect("body_entered",self,"body_close_door1")
	$Torre.connect("body_exited",self,"body_leave_door1")
	$Torre2.connect("body_entered",self,"body_close_door2")
	$Torre2.connect("body_exited",self,"body_leave_door2")
	$Enemy.connect("body_entered",self,"body_close_enemy")
	$Enemy.connect("body_exited",self,"body_leave_enemy")
	$CanvasLayer/inter.connect("pressed",self,"interact")
	pass
func enter_minigame(minigame):
	game = minigame_list[minigame].instance()
	current_minigame_index = minigame
	for child in $CanvasLayer.get_children():
		child.disabled = true
		child.hide()
	
	$Minigame_location.add_child(game)
	game.connect("minigame_result",self,"exit_minigame")
	$Player/Camera2D.current = false
	$Minigame_location/Camera2D.current = true
	
	pass
func exit_minigame(result):
	if result == false:
		game.queue_free()
		game = minigame_list[current_minigame_index].instance()
		$Minigame_location.add_child(game)
		game.connect("minigame_result",self,"exit_minigame")
		$Player/Camera2D.current = false
		$Minigame_location/Camera2D.current = true
		return
	game.queue_free()
	if current_minigame_index == 1:
		door_locked = false
	for child in $CanvasLayer.get_children():
		child.disabled = false
		child.show()
	$Minigame_location/Camera2D.current = false
	$Player/Camera2D.current = true
	button_check()
	pass
func button_check():
	if on_door_1 or on_door_2 or on_npc or on_enemy:
		$CanvasLayer/inter.disabled = false
	else:
		$CanvasLayer/inter.disabled = true
func interact():
	if on_door_1:
		if door_locked:
			enter_minigame(1)
		else:
			$Player.position = $Torre2.position
			on_door_1 = false
			on_door_2 = true
			button_check()
	elif on_door_2:
		$Player.position = $Torre.position
		on_door_2 = false
		on_door_1 = true
		button_check()
	elif on_npc:
		print("oi")
	elif on_enemy:
		enter_minigame(0)
		print("tchau")

func body_close_npc(body):
	if body.is_in_group("Player"):
		on_npc = true
		$NPC/diag.show()
		button_check()
	pass

func body_leave_npc(body):
	if body.is_in_group("Player"):
		on_npc = false
		$NPC/diag.hide()
		button_check()
	pass

func body_close_door1(body):
	if body.is_in_group("Player"):
		on_door_1 = true
		$Torre/diag.show()
		button_check()
	pass

func body_leave_door1(body):
	if body.is_in_group("Player"):
		on_door_1 = false
		$Torre/diag.hide()
		button_check()
	pass
func body_close_door2(body):
	if body.is_in_group("Player"):
		on_door_2 = true
		$Torre2/diag.show()
		button_check()
	pass

func body_leave_door2(body):
	if body.is_in_group("Player"):
		on_door_2 = false
		$Torre2/diag.hide()
		button_check()
	pass

func body_close_enemy(body):
	if body.is_in_group("Player"):
		on_enemy = true
		$Enemy/diag.show()
		button_check()
	pass

func body_leave_enemy(body):
	if body.is_in_group("Player"):
		on_enemy = false
		$Enemy/diag.hide()
		button_check()
	pass
