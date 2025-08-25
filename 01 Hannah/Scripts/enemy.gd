extends CharacterBody2D

# sound effects
@onready var player_enterSFX = $enterSFX # when player enter detection area
@onready var damageSFX = $damageSFX  # when enemy takes damge
@onready var deathSFX = $deadSFX # when death is triggered

# ----- variables -----
var speed = 40 # movment speed
var dead = false 
var player_chase = false 
var player = null
var last_direction := Vector2.DOWN
var health = 100 # health amount
var player_inattack_range = false # for attacking
var can_take_damage = true
var is_attacking = false
var attack_cooldown = true

# knockback
var knockback_power := 300
var knockback_timer := 0.0


# FSM States
enum {
	IDLE,
	CHASE,
	ATTACK,
	DEAD
}

var state = IDLE

# ----------------------

func _ready():
	last_direction = Vector2.DOWN  # Ensure direction is initialized
	$AudioStreamPlayer2D.play()
	play_idle_animation()
	change_state(IDLE)

func _physics_process(_delta):
	match state:
		IDLE:
			state_idle()
		CHASE:
			state_chase()
		ATTACK:
			state_attack()
		DEAD:
			state_dead()
	if knockback_timer > 0:
		knockback_timer -= _delta
		move_and_slide()
		return


	deal_with_damage()

# ---- FSM transition ----

func change_state(new_state):
	if state == new_state:
		return

	# Exit logic
	match state:
		ATTACK:
			is_attacking = false
		_:
			pass

	state = new_state

	# enter logic
	match state:
		IDLE:
			play_idle_animation()
		CHASE:
			pass
		ATTACK:
			start_attack()
		DEAD:
			start_death()

# FSM state logic 

func state_idle():
	velocity = Vector2.ZERO
	move_and_slide()

func state_chase():
	if player and not is_attacking:
		var direction = (player.position - position).normalized()
		last_direction = direction
		velocity = direction * speed
		move_and_slide()
		play_walk_animation(direction)
	else:
		change_state(IDLE)

func state_attack():
	if not is_attacking and attack_cooldown and player_inattack_range:
		start_attack()
	elif not player_inattack_range:
		change_state(CHASE if player_chase else IDLE)

func state_dead():
	$detection_area/Detection_collsion.disabled = true
	# IRENE HERE
	# so you can still collide with the carcass
	# $Enemy_collision.disabled = true
	# nvm it brought up a new set of problems...
	$e_hitbox/e_hitbox_collision.disabled = true
	velocity = Vector2.ZERO
	move_and_slide()

# FSM action handlers 

func start_attack():
	is_attacking = true
	attack_cooldown = false
	velocity = Vector2.ZERO

	play_attack_animation()

	$attack_cooldown_timer.start()

func start_death():
	dead = true
	can_take_damage = false
	velocity = Vector2.ZERO
	play_death_animation()
	gobal.bad_moral_points += 2
	print("Bad moral points because of killing hooman: ", gobal.bad_moral_points)

# -----animations------ 

func get_direction_name(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "r" if dir.x > 0 else "l"
	else:
		return "b" if dir.y < 0 else "f"

func play_walk_animation(dir: Vector2):
	match get_direction_name(dir):
		"f": $AnimatedSprite2D.play("e_walk_f")
		"b": $AnimatedSprite2D.play("e_walk_b")
		"l": $AnimatedSprite2D.play("e_walk_l")
		"r": $AnimatedSprite2D.play("e_walk_r")

func play_idle_animation():
	match get_direction_name(last_direction):
		"f": $AnimatedSprite2D.play("e_idle_f")
		"b": $AnimatedSprite2D.play("e_idle_b")
		"l": $AnimatedSprite2D.play("e_idle_l")
		"r": $AnimatedSprite2D.play("e_idle_r")

func play_attack_animation():
	match get_direction_name(last_direction):
		"f": $AnimatedSprite2D.play("e_attack_f")
		"b": $AnimatedSprite2D.play("e_attack_b")
		"l": $AnimatedSprite2D.play("e_attack_l")
		"r": $AnimatedSprite2D.play("e_attack_r")

func play_death_animation():
	match get_direction_name(last_direction):
		"f": $AnimatedSprite2D.play("e_death_f")
		"b": $AnimatedSprite2D.play("e_death_b")
		"l": $AnimatedSprite2D.play("e_death_l")
		"r": $AnimatedSprite2D.play("e_death_r")

# -----detections-----
func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true
		player_enterSFX.play() # sound effect 
		if not dead:
			change_state(CHASE)

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false
		if not dead:
			change_state(IDLE)

func _on_e_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_range = true
		if not dead and attack_cooldown:
			change_state(ATTACK)

func _on_e_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false
		if not dead:
			change_state(CHASE if player_chase else IDLE)

# damage (taking and dealing)

func deal_with_damage():
	if player_inattack_range and gobal.player_current_attack:
		if can_take_damage:
			health -= 20
			damageSFX.play() # sound effect
			flash()
			knockback((position - player.position))
			$take_damage.start()
			can_take_damage = false
			print("Enemy Health = ", health) # Debugging
			if health <= 0 and not dead:
				deathSFX.play() # sound effect
				change_state(DEAD)

func _on_take_damage_timeout():
	can_take_damage = true

# callbacks

func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false
		if not dead:
			if player_inattack_range:
				change_state(ATTACK)  # continue attacking while player in range
			else:
				change_state(CHASE if player_chase else IDLE)

func _on_animated_sprite_2d_frame_changed():
	# 4 sycning the enemy attack animation with when the player takes damage (fine tuning)
	if is_attacking:
		var mid_frame = int($AnimatedSprite2D.sprite_frames.get_frame_count($AnimatedSprite2D.animation) / 3)
		if $AnimatedSprite2D.frame == mid_frame:
			if player and player.has_method("enemy_attack") and player_inattack_range:
				player.enemy_attack(global_position)

func _on_attack_timer_timeout():
	is_attacking = false

func _on_attack_cooldown_timer_timeout():
	attack_cooldown = true
	if player_inattack_range and not dead:
		change_state(ATTACK)  # queue next attack immediately

# ----damage indicatication----
func flash(): # flashes a differnt colour when player is hit by enemy
	var original_color = modulate # change colpur
	modulate = Color(1, 0.3, 0.3, 1) # colour code
	await get_tree().create_timer(0.1).timeout # timer 4 how long change last
	modulate = original_color # return to original colour


func knockback(direction: Vector2): 
	velocity = direction.normalized() * knockback_power 
	knockback_timer = 0.2  # timer 4 recovery time


# --------------------------------------------IRENE-------------------------------------------------
func is_alive():
	if dead:
		return false
	else:
		return true
		
