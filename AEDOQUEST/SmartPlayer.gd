extends AudioStreamPlayer

class_name SmartPlayer
const dbps = 120
func _ready():
	set_physics_process(false)
	pass

func start_death():
	set_physics_process(true)

func _physics_process(delta):
	volume_db-=dbps*delta
	if volume_db <= -20:
		queue_free()
	pass
