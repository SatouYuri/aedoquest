extends Node2D

#Variáveis de Estado
var bpm : int
var time : float
var side : int

#Código Inicial
func _ready():
	bpm = 60
	$Timer.wait_time = bpm/60.0
	time = 0
	side = 0

#Código Principal
func _physics_process(delta):
	time += delta

func _on_Timer_timeout():
	$Tempo.play()
	side == 1
