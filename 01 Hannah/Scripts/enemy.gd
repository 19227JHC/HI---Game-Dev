extends CharacterBody2D

# ----- Variables -----
var speed = 40
var dead = false
var player_chase = false
var player = null
var last_direction := Vector2.DOWN

var health = 100
var player_inattack_range = false
var can_take_damage = true
var is_attacking = false
var attack_cooldown = true

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
	play_idle_animation()
	change_state(IDLE)
	


func _physics_process(_delta):
	match state:
		IDLE:
			state_idle()
		CHASE:
			state_chase()
		ATTACK:
			pass # Attack is handled in animation callback
		DEAD:
			state_dead()

	deal_with_damage()


# FSM TRANSITION 

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

	# Enter logic
	match state:
		IDLE:
			play_idle_animation()
		CHASE:
			pass
		ATTACK:
			start_attack()
		DEAD:
			start_death()

# FSM STATE LOGIC 

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

func state_dead():
	$detection_area/Detection_collsion.disabled = true
	$Enemy_collision.disabled = true
	$e_hitbox/e_hitbox_collision.disabled = true
	velocity = Vector2.ZERO
	move_and_slide()

# FSM ACTION HANDLERS 

func start_attack():
	is_attacking = true
	attack_cooldown = false
	velocity = Vector2.ZERO

	play_attack_animation()
	if player and player.has_method("enemy_attack"):
		player.health -= 20
		print("Player Health: ", player.health)

	$attack_cooldown_timer.start()

func start_death():
	dead = true
	can_take_damage = false
	velocity = Vector2.ZERO
	play_death_animation()

# ANIMATION HELPERS 

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

# DETECTION 

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		player = body
		player_chase = true
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

# DAMAGE 

func deal_with_damage():
	if player_inattack_range and gobal.player_current_attack:
		if can_take_damage:
			health -= 20
			$take_damage.start()
			can_take_damage = false
			print("Enemy Health = ", health)
			if health <= 0 and not dead:
				change_state(DEAD)

func _on_take_damage_timeout():
	can_take_damage = true

# CALLBACKS 	

func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking = false
		if not dead:
			change_state(CHASE if player_chase else IDLE)

func _on_attack_timer_timeout():
	is_attacking = false

func _on_attack_cooldown_timer_timeout():
	attack_cooldown = true
