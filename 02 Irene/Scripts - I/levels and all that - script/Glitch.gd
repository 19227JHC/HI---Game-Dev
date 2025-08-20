""" extends ColorRect

@onready var glitch_material := material as ShaderMaterial

func _ready():
	start_glitch_loop()

func start_glitch_loop():
	glitch_loop()

func glitch_loop() -> void:
	await get_tree().create_timer(randf_range(10.0, 20.0)).timeout

	# Enable glitch
	glitch_material.set_shader_parameter("shake_rate", 0.8)
	glitch_material.set_shader_parameter("shake_power", 0.04)

	# Keep it glitching for 0.4–0.7 sec
	await get_tree().create_timer(randf_range(0.2, 0.5)).timeout

	# Disable glitch
	glitch_material.set_shader_parameter("shake_rate", 0.0)
	glitch_material.set_shader_parameter("shake_power", 0.0)

	# Repeat
	glitch_loop()
"""

extends ColorRect

@onready var glitch_material := material as ShaderMaterial
@onready var glitch_sound := $GlitchSound

func _ready():
	start_glitch_loop()

func start_glitch_loop():
	glitch_loop()

func glitch_loop() -> void:
	await get_tree().create_timer(randf_range(5.0, 10.0)).timeout

	# Start glitch effect
	glitch_material.set_shader_parameter("shake_rate", 0.8)
	glitch_material.set_shader_parameter("shake_power", 0.04)
	glitch_sound.play()

	# Duration of glitch burst
	await get_tree().create_timer(randf_range(0.4, 0.7)).timeout

	# Stop glitch effect
	glitch_material.set_shader_parameter("shake_rate", 0.0)
	glitch_material.set_shader_parameter("shake_power", 0.0)

	glitch_loop()
