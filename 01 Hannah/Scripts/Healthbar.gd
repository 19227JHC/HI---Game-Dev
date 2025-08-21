extends TextureProgressBar

@export var player: Player # 4 conection to player

var original_position := Vector2.ZERO
var shaking := false 

func _ready():
	if player:
		player.healthChanged.connect(update) # connect to player health change
		print("Connected to player") # debugging
	else:
		print("HealthBar: No player assigned!") # debugging

	original_position = position # 4 shake effect 
	update() # call update function

func update(): # Function to update displayed health
	if player:
		value = float(player.currentHealth) * 100 / float(player.maxHealth)
		flash() # call flash
		shake() # call shake

func flash(): # flash the health bar
	var original_color = modulate
	modulate = Color(1, 0.3, 0.3, 1)

	await get_tree().create_timer(0.1).timeout
	modulate = original_color

func shake(): # shake the health bar
	if shaking:
		return
	shaking = true

	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", original_position + Vector2(5, 0), 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", original_position - Vector2(5, 0), 0.05).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", original_position, 0.05).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(func(): shaking = false)
