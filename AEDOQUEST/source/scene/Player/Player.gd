extends KinematicBody2D

const SPEED = 300
const GRAVITY = 800
var velocity = Vector2()

var is_walking = true
var left_pressed = false
var right_pressed = false

func press_left():
	left_pressed = true
func unpress_left():
	left_pressed = false
func press_right():
	right_pressed = true
func unpress_right():
	right_pressed = false


func _ready():
	add_to_group("Player")
	set_physics_process(true)
	pass
func walking(val):
	is_walking = val
	if val == false:
		unpress_left()
		unpress_right()
func sprite_left():
	$AQProtag.flip_h = true
func sprite_right():
	$AQProtag.flip_h = false
func _physics_process(delta):
	if is_walking:
		velocity.x = 0
		velocity.y += GRAVITY*delta
		if is_on_floor():
			velocity.y = 0
		if left_pressed:
			sprite_left()
			velocity.x -= SPEED
		if right_pressed:
			sprite_right()
			velocity.x += SPEED
		move_and_slide_with_snap(velocity,  Vector2(0,10), Vector2(0,-1))
	pass
