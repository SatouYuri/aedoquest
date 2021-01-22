extends Area2D

#Constantes
const SPEED = 250

#Variáveis de Estado
var velocity = Vector2()
var direction = 1
var damage = 0

#Funções
func setDirection(direction : int):
	self.direction = direction
	if direction == -1:
		$AnimatedSprite.modulate.g = 0
		$AnimatedSprite.modulate.r = 0
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.position.x *= -1
		$CollisionShape2D.position.x *= -1

#Código Principal
func _physics_process(delta):
	velocity.x = SPEED * direction * delta
	translate(velocity)
	
	if (position.x > 1240 and direction == 1) or (position.x < 220 and direction == -1):
		queue_free()
