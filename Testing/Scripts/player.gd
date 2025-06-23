extends CharacterBody2D

var max_speed = 100
var last_direction := Vector2(1, 0)
var is_attacking := false

func _physics_process(_delta):
	if is_attacking:
		velocity = Vector2.ZERO  # Prevent movement while attacking
	else:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * max_speed
		move_and_slide()

		if direction.length() > 0:
			last_direction = direction
			play_walk_animation(direction)
		else:
			play_idle_animation(last_direction)

	# Handle attack input
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()

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

func attack():
	is_attacking = true
	play_attack_animation(last_direction)

func play_attack_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("attack_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("attack_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("attack_front")
	elif direction.y < 0:
		$AnimatedSprite2D.play("attack_back")

	# Wait for the animation to finish (non-blocking)
	await $AnimatedSprite2D.animation_finished
	is_attacking = false
