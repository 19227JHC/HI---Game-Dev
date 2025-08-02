extends CharacterBody2D

class_name Player

signal healthChanged

@export var maxHealth = 160
@export var currentHealth: int = maxHealth

# Movement
var max_speed = 100
var last_direction := Vector2(1, 0)

# Combat
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true
var attack_ip = false
var death_anim_played = false

func _physics_process(_delta):
	if not player_alive:
		return

	attack()

	if currentHealth <= 0 and not death_anim_played:
		player_alive = false
		currentHealth = 0
		death_anim_played = true
		print("player has been killed")
		play_death_animation(last_direction)
		return

	var direction = Input.get_vector("left", "right", "up", "down")
	if attack_ip:
		velocity = Vector2.ZERO
	else:
		velocity = direction * max_speed

	move_and_slide()

	if not attack_ip:
		if direction.length() > 0:
			last_direction = direction
			play_walk_animation(direction)
		else:
			play_idle_animation(last_direction)

func enemy_attack(): 
	if player_alive:
		currentHealth -= 20
		healthChanged.emit()
		print(currentHealth)

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

func play_death_animation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("death_right")
	elif direction.x < 0:
		$AnimatedSprite2D.play("death_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("death_front")
	elif direction.y < 0:
		$AnimatedSprite2D.play("death_back")

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func _on_p_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_p_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func attack():
	if Input.is_action_just_pressed("attack") and player_alive:
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

func _on_animated_sprite_2d_animation_finished():
	if death_anim_played and $AnimatedSprite2D.animation.begins_with("death"):
		queue_free()
		get_node("/root/Main/CanvasLayer/DeadScreen").show_death_screen()

func player():
	pass
