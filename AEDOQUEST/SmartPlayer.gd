extends AudioStreamPlayer

class_name SmartPlayer
const dbps = 120
var lifespan = 1.0
var time = 0.0
func _ready():
	set_physics_process(true)
	pass

func _physics_process(delta):
	time += delta
	if time >= lifespan:
		volume_db-=dbps*delta
		if volume_db <= -20:
			queue_free()
	pass
