extends Node2D

signal minigame_result(result)

var current_note
var bpm = 60
var genius = false
var padrao = [[0],[3,3,2,2,2],[2,2,1],[3,3,3,3,2,3,3]]
var anims = ["whole","half","quarter","eighth"]
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

func play_met():
	$Metronomo.play()

func kill_current():
	current_note.die()
	next()

func enable_buttons():
	for child in $Notas.get_children():
		if child.name[0] == 'b':
			child.get_node("Label").modulate.a = 1
			child.get_node("Panel").show()
			child.disabled = false

func disable_buttons():
	for child in $Notas.get_children():
		if child.name[0] == 'b':
			child.get_node("Label").modulate.a = 0.5
			if not genius:
				child.get_node("Panel").hide()
			child.disabled = true

func _ready():
	disable_buttons()
	$Notas/b1.connect("pressed",self,"add_note",[0])
	$Notas/b2.connect("pressed",self,"add_note",[1])
	$Notas/b3.connect("pressed",self,"add_note",[2])
	$Notas/b4.connect("pressed",self,"add_note",[3])
	$Notas/b5.connect("pressed",self,"delete_last")
	$Playbutton.connect("pressed", self,"playmusic")
	$Metronomo/Timer.wait_time = 60.0/bpm
	$Metronomo/Timer.connect("timeout",$Metronomo,"play")
	yield(get_tree().create_timer(1),"timeout")
	$Lock.connect("pronto",self,"pronto")
	playmusic()

func pronto():
	$Lock.disconnect("pronto",self,"pronto")
	yield(get_tree().create_timer(2), "timeout")
	emit_signal("minigame_result", true)
	pass

func playmusic():
	if sequence_index == padrao.size():
			return
			pass
	elif not is_playing:
		disable_buttons()
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
		
		is_playing = false
		enable_buttons()
		return
	var new_player = SmartPlayer.new()
	new_player.stream = load(sounds_path+sounds[sequence_index][sound_index]+".ogg")
	add_child(new_player)
	new_player.play()
	$Notas/AnimationPlayer.play(anims[padrao[sequence_index][sound_index]])
	current_note = new_player
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
		disable_buttons()
		yield(get_tree().create_timer(0.2), "timeout")
		delete_all()
		$Lock.seqSolveLock()
		
		$Metronomo/Timer.stop()
		sequence_index+=1
		yield(get_tree().create_timer(2), "timeout")
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

