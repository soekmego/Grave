extends KinematicBody2D

export (int) var speed = 100
onready var sprite = $Sprite

enum {IDLE, RUN, ROLL}
var direction = Vector2()
var state
var anim = ""
var new_anim

func _ready():
	change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = "idle"
		RUN:
			new_anim = "run"
		ROLL:
			new_anim = "roll"

func get_input():
	direction = Vector2()
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var roll = Input.is_action_pressed("ui_select")
	
	if right and state != ROLL:
		change_state(RUN)
		direction.x += 1
		sprite.flip_h = false
	
	if left and state != ROLL:
		change_state(RUN)
		direction.x -= 1
		sprite.flip_h = true
	
	if roll:
		change_state(ROLL)
	
	if !right and !left and state == RUN:
		change_state(IDLE)
	
	direction = direction.normalized() * speed

func _process(delta):
	get_input()
	if anim != new_anim:
		anim = new_anim
		$Animation.play(anim)
	move_and_slide(direction)
	#print(state)

func _on_Animation_animation_finished(roll):
	change_state(IDLE)
