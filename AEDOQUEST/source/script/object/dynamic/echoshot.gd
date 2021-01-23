extends Area2D

#Constantes
onready var SPEED = 250

#Variáveis de Estado
var line : String = ""
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
		$AnimatedSprite.play("fire")

#Código Principal
func _physics_process(delta):
	velocity.x = SPEED * direction * delta
	translate(velocity)
	
	#Desinstanciamento por atingir limite do caminho
	if (position.x > 1240 and direction == 1):
		get_parent().takeDamage(5.00)
		queue_free()
	elif (position.x < 220 and direction == -1):
		
		get_parent().takeDamage(5.00)
		get_parent().clearShots()
	
	#Disparo Inimigo
	if direction == -1 and position.x < 1032 and $AnimatedSprite.animation == "fire":
		$AnimatedSprite.play("shoot")

func _on_EchoShot_area_entered(area):
	if "EchoShot" in area.name and area.direction != self.direction and area.direction == -1:
		get_parent().gradFeedbackList[get_parent().getConstByLine(line)] = true
		if position.x <= 1240 and position.x >= 220:
			get_parent().get_node("Pentagram").get_node("Line" + line).get_node("FeedbackGrad").modulate.a = 1.00
			get_parent().get_node("Pentagram").get_node("Line" + line).get_node("AudioStreamPlayer").play()
			get_parent().earnCharge(2.50)
		else:
			get_parent().takeDamage(5.00)
			get_parent().clearShots()
		area.queue_free()
		queue_free()
