extends Node2D

var bpm = 60
var padrao = [[0],[3,3,2,2,2],[2,2,1],[3,3,3,3,2,3,3]]
var is_playing = false
const sounds_path = "res://source/notes_piano/"
var sounds = [["C4"],["G4","G4","A4","G4","C5"],["C4","D4","E4"],["G4","F4","E4","D4","C4","D4","E4"]]
var sound_index = 0
var sequence_index = 0
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
	$Playbutton.connect("pressed", self,"playmusic")
	$Metronomo/Timer.wait_time = 60.0/bpm
	$AudioTimer.connect("timeout", self,"next")
	$Metronomo/Timer.connect("timeout",$Metronomo,"play")
	yield(get_tree().create_timer(1),"timeout")
	playmusic()

func playmusic():
	if sequence_index == padrao.size():
			get_tree().quit()
			pass
	elif not is_playing:
		sound_index = 0
		$Metronomo.play()
		$Metronomo/Timer.start()
		next()
		pass

func next():
	if sequence_index<sounds.size() and sound_index>=sounds[sequence_index].size():
		$Metronomo/Timer.stop()
		if not $Metronomo.is_playing():
			$Metronomo.play()
		$AudioTimer.stop()
		
		is_playing = false
		return
	play_for_seconds(sounds[sequence_index][sound_index],interval_time[padrao[sequence_index][sound_index]])
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
	if order == padrao[sequence_index]:
		yield(get_tree().create_timer(0.2), "timeout")
		delete_all()
		$UI/AnimationPlayer.play("right")
		
		$Metronomo/Timer.stop()
		$AudioTimer.stop()
		sequence_index+=1
		yield(get_tree().create_timer(1), "timeout")
		playmusic()
		
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
	var new_player = SmartPlayer.new()
	new_player.lifespan = time
	new_player.stream = load(sounds_path+note+".ogg")
	add_child(new_player)
	new_player.play()
	$AudioTimer.wait_time = time
	$AudioTimer.start()

