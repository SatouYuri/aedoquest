extends Node2D

#Variáveis de Estado
var bpm : int
var time : float

#Código Inicial
func _ready():
	bpm = 60
	$Timer.wait_time = bpm/60.0
	time = 0

#Código Principal
func _physics_process(delta):
	time += delta
	$Pointer.rotation_degrees = 60 * cos(PI*time)

func _on_Timer_timeout():
	$Tempo.play()
