extends Node2D

#Constantes
const X_AXIS_START = 220 #TODO: Deixar essa constante menos hardcoded...
const X_AXIS_END = 1240 #TODO: Deixar essa constante menos hardcoded...
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

#Variáveis de Estado
var keyList = []
var enemyList = [];
var keyPressed = [];
var time : float

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
	['E2', ($Pentagram/LineD.position.y + $Pentagram/LineF.position.y)/2], 
	['F2', $Pentagram/LineF.position.y]
]

#                 E      F      G      A      B      C      D      E2     F2
	keyPressed = [false, false, false, false, false, false, false, false, false]

#Funções
func shoot(line : String, zIndex : int, direction : int):
	var newEchoShot = EchoShot.instance()
	add_child(newEchoShot)
	newEchoShot.setDirection(direction)
	if direction == 1:
		newEchoShot.position.x = X_AXIS_START
	else:
		newEchoShot.position.x = X_AXIS_END
	for k in keyList:
		if k[0] == line:
			newEchoShot.position.y = k[1]
			newEchoShot.z_index += zIndex
			break

#Código Principal
func _physics_process(delta):
	time += delta
	
	#Balanço de Background
	$Background/Sprite.position.x += cos(time)
	$Background/Sprite.position.y += sin(time)
	
	#Teste de Contramágica
	if $Timers/TEST_FREQUENCY.is_stopped():
		$Timers/TEST_FREQUENCY.start()
	
	#Input
	if $KeyslayingGUI/Keys/E.pressed:
		if !keyPressed[E]:
			keyPressed[E] = true
			shoot('E', keyPressed.size() - E, 1)
	else:
		keyPressed[E] = false

	if $KeyslayingGUI/Keys/F.pressed:
		if !keyPressed[F]:
			keyPressed[F] = true
			shoot('F', keyPressed.size() - F, 1)
	else:
		keyPressed[F] = false

	if $KeyslayingGUI/Keys/G.pressed:
		if !keyPressed[G]:
			keyPressed[G] = true
			shoot('G', keyPressed.size() - G, 1)
	else:
		keyPressed[G] = false

	if $KeyslayingGUI/Keys/A.pressed:
		if !keyPressed[A]:
			keyPressed[A] = true
			shoot('A', keyPressed.size() - A, 1)
	else:
		keyPressed[A] = false

	if $KeyslayingGUI/Keys/B.pressed:
		if !keyPressed[B]:
			keyPressed[B] = true
			shoot('B', keyPressed.size() - B, 1)
	else:
		keyPressed[B] = false

	if $KeyslayingGUI/Keys/C.pressed:
		if !keyPressed[C]:
			keyPressed[C] = true
			shoot('C', keyPressed.size() - C, 1)
	else:
		keyPressed[C] = false

	if $KeyslayingGUI/Keys/D.pressed:
		if !keyPressed[D]:
			keyPressed[D] = true
			shoot('D', keyPressed.size() - D, 1)
	else:
		keyPressed[D] = false

	if $KeyslayingGUI/Keys/E2.pressed:
		if !keyPressed[E2]:
			keyPressed[E2] = true
			shoot('E2', keyPressed.size() - E2, 1)
	else:
		keyPressed[E2] = false

	if $KeyslayingGUI/Keys/F2.pressed:
		if !keyPressed[F2]:
			keyPressed[F2] = true
			shoot('F2', keyPressed.size() - F2, 1)
	else:
		keyPressed[F2] = false
	

func _on_TEST_FREQUENCY_timeout():
	shoot('G', keyPressed.size() - G, -1)
