extends CharacterBody2D
# setting a max speed
var max_speed = 100

var last_direction := Vector2(1,0)

# running physics
func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * max_speed
	move_and_slide()
	
	if direction.length() > 0:
		last_direction = direction
		play_walk_animation(direction)
		print(direction)
	else:
		play_idle_animation(last_direction)
		print(direction)


		
func play_walk_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("walk_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("walk_front")
	elif direction.y < 0:
		$AnimatedSprite2D.play("walk_back")

func play_idle_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("idle_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("idle_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("idle_front")
	elif direction.y < 0:
		$AnimatedSprite2D.play("idle_back")
