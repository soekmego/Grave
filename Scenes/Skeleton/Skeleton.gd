extends KinematicBody2D

export (int) var speed = 100
onready var sprite = $Sprite

enum {IDLE, RUN, ROLL, ATTACK1, ATTACK2, ATTACK3}
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
		ATTACK1:
			new_anim = "attack1"
		ATTACK2:
			new_anim = "attack2"
		ATTACK3:
			new_anim = "attack3"

func get_input():
	direction = Vector2()
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left")
	var roll = Input.is_action_pressed("ui_select")
	var attack = Input.is_action_pressed("ui_accept")
	
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
		if sprite.flip_h == false:
			direction.x += 3
		else:
			direction.x -= 3
	
	if !right and !left and state == RUN:
		change_state(IDLE)
	
	if attack:
		match state:
			IDLE, RUN:
				change_state(ATTACK1)
			ATTACK1:
				change_state(ATTACK2)
			ATTACK2:
				change_state(ATTACK3)
	
	direction = direction.normalized() * speed

func _process(delta):
	get_input()
	if anim != new_anim:
		anim = new_anim
		$Animation.play(anim)
	move_and_slide(direction)
	#print(state)

func _on_Animation_animation_finished(animation):
	change_state(IDLE)
