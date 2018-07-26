extends KinematicBody2D

export (int) var speed
onready var sprite = $Sprite

enum {IDLE, RUN, ROLL, ATTACK1, ATTACK2, ATTACK3}

onready var direction = Vector2()
onready var state
onready var anim = ""
onready var new_anim
onready var combo = false


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
	var roll = Input.is_action_just_pressed("ui_select")
	var attack = Input.is_action_just_pressed("ui_accept")
	
	if right and state == IDLE:
		change_state(RUN)
		direction.x += 1
		sprite.flip_h = false
	
	elif left and state == IDLE:
		change_state(RUN)
		direction.x -= 1
		sprite.flip_h = true
	
	# TODO - fix roll mechanic.
	# When roll button is hammered, player gets stuck
	# in the last frame of roll animation.
	elif roll and (state == IDLE or state == RUN):
		if $Animation.current_animation != "roll":
			change_state(ROLL)
			if sprite.flip_h == false:
				direction.x += 3
			else:
				direction.x -= 3
	
	elif !right and !left and state == RUN:
		change_state(IDLE)
	
	elif attack:
		match state:
			IDLE, RUN:
				change_state(ATTACK1)
			ATTACK1:
				if combo == true:
					change_state(ATTACK2)
					combo = false
			ATTACK2:
				if combo == true:
					change_state(ATTACK3)
	
	direction = direction.normalized() * speed

func combo_enabled():
	combo = true

func combo_disabled():
	combo = false

func _ready():
	change_state(IDLE)

func _process(delta):
	get_input()
	if anim != new_anim:
		anim = new_anim
		$Animation.play(anim)
	move_and_slide(direction)
