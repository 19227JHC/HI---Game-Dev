extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null
var last_direction := Vector2.DOWN  # Used to remember facing direction

func _physics_process(delta):
	if player_chase and player:
		var direction = (player.position - position).normalized()
		last_direction = direction
		position += direction * speed * delta

		match get_direction_name(direction):
			"f":
				$AnimatedSprite2D.play("e_walk_f")
			"b":
				$AnimatedSprite2D.play("e_walk_b")
			"l":
				$AnimatedSprite2D.play("e_walk_l")
			"r":
				$AnimatedSprite2D.play("e_walk_r")
	else:
		match get_direction_name(last_direction):
			"f":
				$AnimatedSprite2D.play("e_idle_f")
			"b":
				$AnimatedSprite2D.play("e_idle_b")
			"l":
				$AnimatedSprite2D.play("e_idle_l")
			"r":
				$AnimatedSprite2D.play("e_idle_r")

func get_direction_name(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "r" if dir.x > 0 else "l"
	else:
		return "b" if dir.y < 0 else "f"

func _on_detection_area_body_entered(body):
	if body.name == "Player":  # Optional: only chase the player
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		player_chase = false
