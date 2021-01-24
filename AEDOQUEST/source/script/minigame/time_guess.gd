extends Node2D

var bpm = 60
var padrao = [3,3,2,2,2]
const sounds_path = "res://source/notes_strings/"
var sounds = ["G4","G4","A4","G4","C5"]
var sound_index = 0
var interval_time = [240.0/bpm,120.0/bpm,60.0/bpm,30.0/bpm]
var note_scenes = [preload("res://source/scene/object/notetime/whole.tscn"),
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
	
	$AudioStreamPlayer/Timer.connect("timeout", self,"next")
	$AudioStreamPlayer/Timer.wait_time = 1
	$AudioStreamPlayer/Timer.start()

func next():
	if sound_index>=sounds.size():
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer/Timer.stop()
		yield(get_tree().create_timer(1), "timeout")
		sound_index = 0
	print(interval_time[padrao[sound_index]])
	play_for_seconds(sounds[sound_index],interval_time[padrao[sound_index]])
	sound_index+=1
	pass

func add_note(var index):
	
	if index < 0 or index > 3:
		return
	var new_child = note_scenes[index].instance()
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

func play_for_seconds(note,time):
	$AudioStreamPlayer.stream = load(sounds_path+note+".ogg")
	$AudioStreamPlayer.play()
	$AudioStreamPlayer/Timer.wait_time = time
	$AudioStreamPlayer/Timer.start()
