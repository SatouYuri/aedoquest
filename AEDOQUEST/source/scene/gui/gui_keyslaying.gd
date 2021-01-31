extends MarginContainer

func enable_key(letra: String):
	var but = $Keys.get_node(letra)
	but.disabled = false
	pass
func disable_key(letra: String):
	var but = $Keys.get_node(letra)
	but.disabled = true
	pass
func disable_all():
	for child in $Keys.get_children():
		child.disabled = true
func enable_all():
	for child in $Keys.get_children():
		child.disabled = false
func _ready():
	pass
