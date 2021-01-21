extends Area2D

#Constantes
const SPEED = 500

#Variáveis de Estado
var velocity = Vector2()
var direction = 1
var damage = 0

#Código Principal
func _physics_process(delta):
	velocity.x = SPEED * direction * delta
	translate(velocity)
