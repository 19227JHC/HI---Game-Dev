extends TextureProgressBar

@export var player: Player

func _ready():
	if player:
		player.healthChanged.connect(update)
		print("Connected to player")
	else:
		print("HealthBar: No player assigned!")

	update()

func update():
	if player:
		value = float(player.currentHealth) * 100 / float(player.maxHealth)
