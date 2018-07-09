extends KinematicBody2D

export (int) var speed = 100

var direction = Vector2()

func _ready():
	pass

func movement_loop():
	direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	direction = direction.normalized() * speed

#func spritedir_loop():
#	match direction.x:
#		Vector2(1,0):
#			$Sprite.flip_h = false
#		Vector2(-1,0):
#			$Sprite.flip_h = true

func _process(delta):
	movement_loop()
	move_and_slide(direction)
	#spritedir_loop()
	if direction.x > 0:
		$Sprite.flip_h = false
	if direction.x < 0:
		$Sprite.flip_h = true
