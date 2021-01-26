extends Node2D

#Constantes
const X_AXIS_START = 220 #TODO: Deixar essa constante menos hardcoded...
const X_AXIS_END = 1240 #TODO: Deixar essa constante menos hardcoded...
const X_AXIS_ENEMY_PREVIEW = 1032
const X_AXIS_PLAYER_START = 220
const EchoShot = preload("res://source/scene/object/dynamic/echoshot.tscn")
const E = 0
const F = 1
const G = 2
const A = 3
const B = 4
const C = 5
const D = 6
const E2 = 7
const F2 = 8
const testChart = [E, F, G, E, F, G, E, F, G,
					  A, B, B, A, A, B, F, G, F,
					  G, G, G, E, E, E, F, F, F, G]

#Variáveis de Estado
var keyList = []
var gradPlayerList = []
var gradEnemyList = []
var gradFeedbackList = [[],[]]
var enemyList = [];
var keyPressed = [];
var lastLine : String = ""
var time : float
var testChartPos : int = 0

#Código Inicial
func _ready():
	time = 0
	
	keyList = [
	['E', $Pentagram/LineE.position.y], 
	['F', ($Pentagram/LineE.position.y + $Pentagram/LineG.position.y)/2], 
	['G', $Pentagram/LineG.position.y], 
	['A', ($Pentagram/LineG.position.y + $Pentagram/LineB.position.y)/2], 
	['B', $Pentagram/LineB.position.y], 
	['C', ($Pentagram/LineB.position.y + $Pentagram/LineD.position.y)/2], 
	['D', $Pentagram/LineD.position.y], 
	['E2', ($Pentagram/LineD.position.y + $Pentagram/LineF2.position.y)/2], 
	['F2', $Pentagram/LineF2.position.y]
]

#                        E      F      G      A      B      C      D      E2     F2
	keyPressed =       [false, false, false, false, false, false, false, false, false]
	gradPlayerList =   [false, false, false, false, false, false, false, false, false]
	gradEnemyList =    [false, false, false, false, false, false, false, false, false]
	gradFeedbackList = [false, false, false, false, false, false, false, false, false]

#Funções
func getConstByLine(line : String):
	if line == 'E':
		return E
	elif line == 'F':
		return F
	elif line == 'G':
		return G
	elif line == 'A':
		return A
	elif line == 'B':
		return B
	elif line == 'C':
		return C
	elif line == 'D':
		return D
	elif line == 'E2':
		return E2
	elif line == 'F2':
		return F2
	else:
		return null

func getLineByConst(line : int):
	if line == E:
		return 'E'
	elif line == F:
		return 'F'
	elif line == G:
		return 'G'
	elif line == A:
		return 'A'
	elif line == B:
		return 'B'
	elif line == C:
		return 'C'
	elif line == D:
		return 'D'
	elif line == E2:
		return 'E2'
	elif line == F2:
		return 'F2'
	else:
		return null

func shoot(line : String, zIndex : int, direction : int):
	var newEchoShot = EchoShot.instance()
	add_child(newEchoShot)
	newEchoShot.setDirection(direction)
	if direction == -1:
		newEchoShot.SPEED = newEchoShot.SPEED/2
	newEchoShot.line = line
	if direction == 1:
		newEchoShot.position.x = X_AXIS_PLAYER_START
		gradPlayerList[getConstByLine(line)] = true
	else:
		newEchoShot.position.x = X_AXIS_END
		gradEnemyList[getConstByLine(line)] = true
	if direction == 1:
		get_node("Pentagram").get_node("Line" + line).get_node("PlayerGrad").modulate.a = 1.00
	else:
		get_node("Pentagram").get_node("Line" + line).get_node("EnemyGrad").modulate.a = 1.00
	for k in keyList:
		if k[0] == line:
			newEchoShot.position.y = k[1]
			newEchoShot.z_index += zIndex
			break

func earnCharge(chargePercentage : float):
	if $Pentagram/Clef/ClefShade.value < 100.0:
		$Pentagram/Clef/ClefShade.value += chargePercentage
	else:
		$Pentagram/Clef/ClefShade.value = 100.0
		get_tree().change_scene("res://source/scene/minigame/Main.tscn")

func takeDamage(damagePercentage : float):
	if $Pentagram/Clef/Clef.value > 0:
		$Pentagram/Clef/Clef.value -= damagePercentage
	if $Pentagram/Clef/Clef.value <= 0:
		get_tree().change_scene("res://source/scene/minigame/mg_keyslaying.tscn")

func clearShots():
	for s in get_children():
		if "EchoShot" in s.name:
			s.queue_free()

#Código Principal
func _physics_process(delta):
	time += delta
	
	#Balanço de Background
	$Background/Sprite.position.x += cos(time)
	$Background/Sprite.position.y += sin(time)
	
	#Apagando gradientes
	for l in range(gradPlayerList.size()):
		if gradPlayerList[l]:
			var PlayerGrad = get_node("Pentagram").get_node("Line" + getLineByConst(l)).get_node("PlayerGrad")
			if PlayerGrad.modulate.a > 0:
				PlayerGrad.modulate.a -= 0.025
			else:
				PlayerGrad.modulate.a = 0
				gradPlayerList[l] = false
	for l in range(gradEnemyList.size()):
		if gradEnemyList[l]:
			var EnemyGrad = get_node("Pentagram").get_node("Line" + getLineByConst(l)).get_node("EnemyGrad")
			if EnemyGrad.modulate.a > 0:
				EnemyGrad.modulate.a -= 0.025
			else:
				EnemyGrad.modulate.a = 0
				gradEnemyList[l] = false
	for l in range(gradFeedbackList.size()):
		if gradFeedbackList[l]:
			var FeedbackGrad = get_node("Pentagram").get_node("Line" + getLineByConst(l)).get_node("FeedbackGrad")
			if FeedbackGrad.modulate.a > 0:
				FeedbackGrad.modulate.a -= 0.025
			else:
				FeedbackGrad.modulate.a = 0
				gradFeedbackList[l] = false

	#Teste de Contramágica
	if $Timers/TEST_FREQUENCY.is_stopped():
		$Timers/TEST_FREQUENCY.start()
	
	#Input
	if $KeyslayingGUI/Keys/E.pressed or Input.is_action_just_pressed("AQ_1"):
		if !keyPressed[E]:
			keyPressed[E] = true
			shoot('E', keyPressed.size() - E, 1)
	else:
		keyPressed[E] = false

	if $KeyslayingGUI/Keys/F.pressed or Input.is_action_just_pressed("AQ_2"):
		if !keyPressed[F]:
			keyPressed[F] = true
			shoot('F', keyPressed.size() - F, 1)
	else:
		keyPressed[F] = false

	if $KeyslayingGUI/Keys/G.pressed or Input.is_action_just_pressed("AQ_3"):
		if !keyPressed[G]:
			keyPressed[G] = true
			shoot('G', keyPressed.size() - G, 1)
	else:
		keyPressed[G] = false

	if $KeyslayingGUI/Keys/A.pressed or Input.is_action_just_pressed("AQ_4"):
		if !keyPressed[A]:
			keyPressed[A] = true
			shoot('A', keyPressed.size() - A, 1)
	else:
		keyPressed[A] = false

	if $KeyslayingGUI/Keys/B.pressed or Input.is_action_just_pressed("AQ_5"):
		if !keyPressed[B]:
			keyPressed[B] = true
			shoot('B', keyPressed.size() - B, 1)
	else:
		keyPressed[B] = false

	if $KeyslayingGUI/Keys/C.pressed or Input.is_action_just_pressed("AQ_6"):
		if !keyPressed[C]:
			keyPressed[C] = true
			shoot('C', keyPressed.size() - C, 1)
	else:
		keyPressed[C] = false

	if $KeyslayingGUI/Keys/D.pressed or Input.is_action_just_pressed("AQ_7"):
		if !keyPressed[D]:
			keyPressed[D] = true
			shoot('D', keyPressed.size() - D, 1)
	else:
		keyPressed[D] = false

	if $KeyslayingGUI/Keys/E2.pressed or Input.is_action_just_pressed("AQ_8"):
		if !keyPressed[E2]:
			keyPressed[E2] = true
			shoot('E2', keyPressed.size() - E2, 1)
	else:
		keyPressed[E2] = false

	if $KeyslayingGUI/Keys/F2.pressed or Input.is_action_just_pressed("AQ_9"):
		if !keyPressed[F2]:
			keyPressed[F2] = true
			shoot('F2', keyPressed.size() - F2, 1)
	else:
		keyPressed[F2] = false

func _on_TEST_FREQUENCY_timeout():
	#var randLine = getLineByConst(int(rand_range(E, F2)))
	#shoot(randLine, keyPressed.size() - getConstByLine(randLine), -1)
	if testChartPos < testChart.size():
		shoot(getLineByConst(testChart[testChartPos]), keyPressed.size() - testChart[testChartPos], -1)
	else:
		testChartPos = -1
	testChartPos += 1
