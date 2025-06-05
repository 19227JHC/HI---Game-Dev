extends CharacterBody2D

@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var acceleration = 0.1
@export_range(0, 1) var deceleration = 0.1

const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction *  speed, speed * acceleration)
		animated_sprite.play("WalkR")
		animated_sprite.flip_h = direction < 0
		
	else:
		velocity.x = move_toward(velocity.x, 0,  walk_speed * deceleration)
		animated_sprite.play("Idle")

	move_and_slide()
