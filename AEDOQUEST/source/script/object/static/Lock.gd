extends Node2D

#Constantes
const LAYER_COUNT = 4
const ROTATION_SPEED = 90
const MODULATION_SPEED = 3

#Variáveis de Estado
#                        Layer0 Layer1 Layer2 Layer3
var solvedTriggerList = [false, false, false, false]
var solvedList =        [false, false, false, false]

#Código Inicial
func _ready():
	randomLock()

#Funções
func randomLock():
	for l in get_node("Layers").get_children():
		randomize()
		l.rotation_degrees = rand_range(-360, 360.0)

func solveLayer(layer : int):
	solvedTriggerList[layer] = true

func solveLock():
	for i in range(LAYER_COUNT):
		solveLayer(i)

func seqSolveLock():
	for s in range(solvedList.size()):
		if !solvedList[s]:
			solvedTriggerList[s] = true
			break
	if isSolved():
		return true
	else:
		return false

func isSolved():
	var solvedLocks : int = 0
	for l in get_node("Layers").get_children():
		if l.rotation_degrees == 0:
			solvedLocks += 1
	if solvedLocks == LAYER_COUNT:
		return true
	else:
		return false

#Código Principal
func _physics_process(delta):
	for l in range(solvedTriggerList.size()):
		if solvedTriggerList[l]:
			var layer = get_node("Layers").get_node("Layer" + str(l))
			if layer.rotation_degrees > 1:
				layer.rotation_degrees -= delta * ROTATION_SPEED
			elif layer.rotation_degrees < -1:
				layer.rotation_degrees += delta * ROTATION_SPEED
			else:
				layer.rotation_degrees = 0
				solvedList[l] = true
	if isSolved():
		for l in get_node("Layers").get_children():
			if l.modulate.r > 0.0:
				l.modulate.r -= delta * MODULATION_SPEED
			else:
				l.modulate.r = 0.0
			
			if l.modulate.b > 0.0:
				l.modulate.b -= delta * MODULATION_SPEED
			else:
				l.modulate.b = 0.0

	# NOTA / WIP: Remover depois...
	if Input.is_action_just_pressed("AQ_1"):
		seqSolveLock()
	if Input.is_action_just_pressed("AQ_2"):
		solveLayer(1)
	if Input.is_action_just_pressed("AQ_3"):
		solveLayer(2)
	if Input.is_action_just_pressed("AQ_4"):
		solveLayer(3)
