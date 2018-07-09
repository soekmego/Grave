extends KinematicBody2D

export (int) var speed = 100
onready var sprite = $Sprite

var direction = Vector2()
var anim = ""

func _ready():
	pass

func movement_loop():
	direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	direction = direction.normalized() * speed

func spritedir_loop():
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true

func animation_loop():
	var new_anim = "idle"
	
	if direction.x == 0:
		new_anim = "idle"
	else:
		new_anim = "run"
	
	if new_anim != anim:
		anim = new_anim
		$Animation.play(anim)

func _process(delta):
	movement_loop()
	move_and_slide(direction)
	spritedir_loop()
	animation_loop()
	
