extends Node2D

var on_door_1 = false
var on_door_2 = false
var on_npc = false

var door_locked = true
var enemy_defeated = false
var entered_tower = false

var talk_dict = {}

var current_talk = []
var talk_index = 0
var talking = false

var current_minigame_index = -1 
var game

var minigame_list = [load("res://source/scene/minigame/mg_keyslaying.tscn"),
					load("res://source/scene/minigame/time_guess.tscn")]
func _ready():
	var file = File.new()
	file.open("res://source/scene/mapa/falas.json", file.READ)
	var text = file.get_as_text()
	var json_res = JSON.parse(text)
	file.close()
	if json_res.error == OK:
		talk_dict = json_res.result
		print(talk_dict["Cores"])
	else:
		print(json_res.error)
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
	$CanvasLayer/inter.connect("pressed",self,"interact")
	pass

func fase_mg1(fase):
	if fase == 1:
		current_talk = talk_dict["Batalha"]["1"]
		falando()
	else:
		game.prox_fase()
func fase_mg2(fase):
	print("oi2")
	if fase == 6:
		game.genius=  false
	if str(fase) in talk_dict["Fechadura"].keys():
		current_talk = talk_dict["Fechadura"][str(fase)]
		falando()
	else:
		game.playmusic()

func falando():
	$Player.walking(false)
	talking = true
	disable_canvas()
	$CanvasLayer/inter.disabled = false
	$CanvasLayer/Textbox.show()
	$CanvasLayer/inter.show()
	talk_index = 0
	prox_fala()

func parou_de_falar():
	$Player.walking(true)
	enable_canvas()
	talking = false
	$CanvasLayer/Textbox.hide()
	pass
func prox_fala():
	$CanvasLayer/inter.disabled = false
	$CanvasLayer/Textbox.show()
	$CanvasLayer/inter.show()
	if talk_index == current_talk.size():
		parou_de_falar()
		return
	var texto = current_talk[talk_index]
	var nome = texto[0]
	if nome == "com":
		if texto[1] == "minigame1":
			parou_de_falar()
			$Enemy/crimson_shield_ui1.hide()
			enter_minigame(0)
		elif texto[1] == "vazar":
			$Enemy/megumin.texture = load("res://source/sprite/character/CRIMSONWITCH_fly2.png")
			parou_de_falar()
			$Enemy/AnimationPlayer.play("vazar")
		elif texto[1] == "enabledoor":
			$Torre.monitorable = true
			$Torre.monitoring = true
			talk_index+=1
			prox_fala()
		elif texto[1] == "player_look_left":
			$Player/AQProtag.flip_h = true
			talk_index+=1
			prox_fala()
		elif texto[1] == "enter":
			talk_index+=1
			$CanvasLayer/inter.disabled = true
			$Camera_NPC/AnimationPlayer.play("Entrar")
			
		elif texto[1] == "go_to_tower":
			entered_tower = true
			$Player.show()
			$Player/Camera2D.current = true
			$Player.position = $Torre2.position
			$NPC/AQNPC2.position.x = 0
			on_door_1 = false
			on_door_2 = true
			button_check()
			talk_index+=1
			prox_fala()
		elif texto[1] == "player_leave":
			talk_index+=1
			$CanvasLayer/inter.disabled = true
			$Camera_NPC/AnimationPlayer.play("Sair")
			pass
		elif texto[1] == "tuba":
			$NPC/AQNPC2.hide()
			$NPC/AQNPC1_CURSE3.show()
			talk_index+=1
			prox_fala()
		elif texto[1] == "prox_fase_mg1":
			parou_de_falar()
			disable_canvas()
			game.prox_fase()
			pass
		elif texto[1] == "prox_fase_mg2":
			print("oi3")
			parou_de_falar()
			disable_canvas()
			game.playmusic()
		elif texto[1] == "escudo":
			$Enemy/crimson_shield_ui1.show()
			talk_index+=1
			prox_fala()
		elif texto[1] == "fim":
			get_tree().change_scene("res://source/scene/Menus/End.tscn")
	else:
		var fala = texto[1]
		var color
		if nome in talk_dict["Cores"].keys():
			color = Color(talk_dict["Cores"][nome])
			print(talk_dict["Cores"][nome])
		else:
			color = Color("#ffffff")
	
		$CanvasLayer/Textbox/Text.modulate = color
		$CanvasLayer/Textbox/Name.modulate = color
		
		$CanvasLayer/Textbox/Text.text = fala
		$CanvasLayer/Textbox/Name.text = nome
		talk_index+=1

func disable_canvas():
	$CanvasLayer/Left.disabled = true
	$CanvasLayer/Right.disabled = true
	$CanvasLayer/inter.disabled = true
	for child in $CanvasLayer.get_children():
		child.hide()
		
func enable_canvas():
	$CanvasLayer/Left.disabled = false
	$CanvasLayer/Right.disabled = false
	button_check()
	for child in $CanvasLayer.get_children():
		child.show()
	$CanvasLayer/Textbox.hide()
	
func enter_minigame(minigame):
	$AudioStreamPlayer/AnimationPlayer.play("fade_out")
	game = minigame_list[minigame].instance()
	current_minigame_index = minigame
	disable_canvas()
	
	$Minigame_location.add_child(game)
	game.connect("minigame_result",self,"exit_minigame")
	$Player/Camera2D.current = false
	$Minigame_location/Camera2D.current = true
	if minigame == 0:
		game.connect("passou_fase",self,"fase_mg1")
		current_talk = talk_dict["Batalha"]["0"]
		falando()
	elif minigame == 1:
		game.connect("passou_fase",self,"fase_mg2")
		current_talk = talk_dict["Fechadura"]["0"]
		falando()
	
	pass
func voltou():
	current_talk = talk_dict["Rapaz"]["depois"]
	falando()
func exit_minigame(result):
	if result == false:
		game.queue_free()
		game = minigame_list[current_minigame_index].instance()
		$Minigame_location.add_child(game)
		game.connect("minigame_result",self,"exit_minigame")
		$Player/Camera2D.current = false
		$Minigame_location/Camera2D.current = true
		if current_minigame_index == 0:
			game.connect("passou_fase",self,"fase_mg1")
			current_talk = talk_dict["Batalha"]["0"]
			falando()
		return
	$Player.anim_override = true
	$AudioStreamPlayer/AnimationPlayer.play("fade_in")
	game.queue_free()
	enable_canvas()
	$Minigame_location/Camera2D.current = false
	$Player/Camera2D.current = true
	button_check()
	if current_minigame_index == 1:
		door_locked = false
		$NPC/AQNPC2.flip_h = false
		$NPC/AQNPC2.position.x = 350
		$Player.position.x = 1600
		$Player/Camera2D.current = false
		$Camera_NPC.current = true
		current_talk = talk_dict["Rapaz"]["porta"]
		falando()
	if current_minigame_index == 0:
		enemy_defeated = true
		$Player.sprite_right()
		$Enemy/megumin.flip_h = true
		$Player.position.x = 1653.578
		$CanvasLayer/inter.disabled = false
		current_talk = talk_dict["Bruxa"]["depois"]
		falando()
	
	pass
func button_check():
	if talking or on_door_1 or on_door_2 or on_npc:
		$CanvasLayer/inter.disabled = false
	else:
		$CanvasLayer/inter.disabled = true
func interact():
	if talking:
		prox_fala()
		pass
	else:
		if on_door_1:
			if door_locked:
				enter_minigame(1)
			else:
				$Player.position = $Torre2.position
				on_door_1 = false
				on_door_2 = true
				button_check()
		elif on_door_2:
			if enemy_defeated:
				$Camera_NPC.current = true
				$Camera_NPC.position.x = $NPC.position.x
				disable_canvas()
				$Torre.monitorable = false
				$Torre.monitoring = false
				$Camera_NPC/AnimationPlayer.play("Voltar")
			else:
				$Player.position = $Torre.position
				on_door_2 = false
				on_door_1 = true
			button_check()
		elif on_npc:
			if $Player.position.x > $NPC.position.x:
				$NPC/AQNPC2.flip_h = false
				$Player.sprite_left()
			else:
				$NPC/AQNPC2.flip_h = true
				$Player.sprite_right()
			if entered_tower:
				current_talk = talk_dict["Rapaz"]["entrou"]
				falando()
			elif door_locked:
				current_talk = talk_dict["Rapaz"]["antes"]
				falando()

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
		$Player.idle()
		if $Player.position.x > $Enemy.position.x:
				$Enemy/megumin.flip_h = false
				$Player.sprite_left()
		else:
			$Enemy/megumin.flip_h = true
			$Player.sprite_right()
		if not enemy_defeated:
			current_talk = talk_dict["Bruxa"]["antes"]
			falando()
		print("tchau")
	pass
