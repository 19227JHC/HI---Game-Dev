extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


@export var item_name: String = "Pick up"
@export var carry_point_path: NodePath  # Drag your player's carry_point here


var held = false
var player = null
var carry_point = null


func _ready():
	# Set up the interaction behavior dynamically
	var area = $InteractionArea
	area.action_name = item_name
	area.interact = Callable(self, "pickup_or_drop")

	# Optional: find player dynamically
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found!")
		carry_point = player.get_node("carry_point")
		print("Carry point: ", carry_point)
	else:
		print("Player NOT found!")

func pickup_or_drop():
	if not held and carry_point:
		# Pick up
		get_parent().remove_child(self)
		carry_point.add_child(self)
		self.scale = Vector2(1, 1)  # Reset the scale
		position = Vector2.ZERO
		held = true
	else:
		# Drop
		if player:
			get_parent().remove_child(self)
			player.get_parent().add_child(self)
			global_position = carry_point.global_position
			held = false
