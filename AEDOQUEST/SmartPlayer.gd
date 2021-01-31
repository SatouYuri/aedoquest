extends AudioStreamPlayer

class_name SmartPlayer
const dbps = 120
var death = false
func _ready():
	set_physics_process(true)
	pass

func die():
	death = true

func _physics_process(delta):
	if death:
		volume_db-=dbps*delta
		if volume_db <= -20:
			queue_free()
	pass
