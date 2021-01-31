extends Area2D

signal cheguei
#Constantes
onready var SPEED = 500

var velocity = Vector2()
var direction = 1
var damage = 0

func _ready():
	connect("area_entered",self,"_on_EchoShot_area_entered")

#Código Principal
func _physics_process(delta):
	velocity.x = SPEED * direction * delta
	translate(velocity)
	
	#Desinstanciamento por atingir limite do caminho
	if (position.x > 1240 and direction == 1):
		emit_signal("cheguei")
		queue_free()

func _on_EchoShot_area_entered(area):
	if "EchoShot" in area.name:
		get_parent().get_node("Pentagram").get_node("Line" + area.line).get_node("AudioStreamPlayer").play()
		area.queue_free()
