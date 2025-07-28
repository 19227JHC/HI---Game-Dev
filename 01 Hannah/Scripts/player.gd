extends CharacterBody2D

# -----Chracter movement-----
var max_speed = 100
var last_direction := Vector2(1, 0)


# -----Combat-----
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 160
var player_alive = true
var attack_ip = false

# ----physics----
func _physics_process(_delta):
	enemy_attack()
	attack()

	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		queue_free()

	var direction = Input.get_vector("left", "right", "up", "down")

	if attack_ip:
		velocity = Vector2.ZERO  # Stop movement during attack
	else:
		velocity = direction * max_speed

	move_and_slide()

	if not attack_ip:
		if direction.length() > 0:
			last_direction = direction
			play_walk_animation(direction)
		else:
			play_idle_animation(last_direction)

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
	

func player(): # so enemy can detect the player (?)
	pass
	

func _on_p_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_p_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

# taking damage from enemy
func enemy_attack(): 
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	if Input.is_action_just_pressed("attack"):
		gobal.player_current_attack = true
		attack_ip = true

		if abs(last_direction.x) > abs(last_direction.y):
			if last_direction.x > 0:
				$AnimatedSprite2D.play("attack_right")
			else:
				$AnimatedSprite2D.play("attack_left")
		else:
			if last_direction.y > 0:
				$AnimatedSprite2D.play("attack_front")
			else:
				$AnimatedSprite2D.play("attack_back")

		$deal_attack.start()

	
func _on_deal_attack_timeout():
	$deal_attack.stop()
	gobal.player_current_attack = false
	attack_ip = false
 
