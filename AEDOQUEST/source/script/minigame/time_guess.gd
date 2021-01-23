extends Node2D

var padrao = [3,3,2,1]

var notes = [preload("res://source/scene/object/notetime/whole.tscn"),
			preload("res://source/scene/object/notetime/half.tscn"),
			preload("res://source/scene/object/notetime/quarter.tscn"),
			preload("res://source/scene/object/notetime/eighth.tscn")]
var sizes = [800,400,200,100]
var order = []

func _ready():
	$Notas/b1.connect("pressed",self,"add_note",[0])
	$Notas/b2.connect("pressed",self,"add_note",[1])
	$Notas/b3.connect("pressed",self,"add_note",[2])
	$Notas/b4.connect("pressed",self,"add_note",[3])
	$Notas/b5.connect("pressed",self,"delete_last")


func add_note(var index):
	
	if index < 0 or index > 3:
		return
	var new_child = notes[index].instance()
	$Measure.add_child(new_child)
	order.append(index)
	
	var size_total = 0
	
	for child in order:
		size_total += sizes[child]
	if size_total < 800:
		return
	if order == padrao:
		$UI/victory.show()
	else:
		delete_all()
		$UI/AnimationPlayer.play("wrong")
	
func delete_last():
	if $Measure.get_children().size() > 0:
		$Measure.get_children()[-1].queue_free()
		order.pop_back()
		
func delete_all():
	for child in $Measure.get_children():
		child.queue_free()
	order = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
