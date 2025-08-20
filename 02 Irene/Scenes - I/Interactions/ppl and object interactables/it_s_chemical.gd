extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $StaticBody2D/Sprite2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D


@export var item_name: String = "[F] to pick up"
@export var carry_point_path: NodePath  # Drag your player's carry_point here


var held = false
var player = null
var carry_point = null


func _ready():
	# Set up the interaction behavior dynamically
	interaction_area.action_name = item_name
	interaction_area.interact = Callable(self, "pickup_or_drop")

	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found!")
		carry_point = player.get_node("carry_point")
		print("Carry point: ", carry_point)
	else:
		print("Player NOT found!")

# --------------------------------to pick up and drop object----------------------------------------
func pickup_or_drop():
	if not held and carry_point:
		# Clear from table if it was placed there
		var maybe_table = get_parent()
		if maybe_table and maybe_table.has_method("clear_placed_item"):
			maybe_table.clear_placed_item()

		# Disable collision while held
		collision_shape.disabled = true

		# Pick up
		get_parent().remove_child(self)
		carry_point.add_child(self)
		self.scale = Vector2(1, 1)
		position = Vector2.ZERO
		held = true
		if player and player.has_method("set_held_item"):
			player.set_held_item(self)
	else:
		var table = find_nearby_table()
		if table and table.can_drop_item():
			table.place_item(self)
		else:
			# Drop to ground
			if player:
				get_parent().remove_child(self)
				player.get_parent().add_child(self)
				self.scale = Vector2(2, 2)
				
				# Drop slightly in front of the player so it doesn't overlap their collision
				var drop_offset = Vector2(32, 0) # 16 pixels forward
				drop_offset = drop_offset.rotated(player.rotation) # rotate to match player facing
				global_position = carry_point.global_position + drop_offset
		
		# Re-enable collision when dropped or placed
		collision_shape.disabled = false
		
		held = false
		if player and player.has_method("set_held_item"):
			player.set_held_item(null)


# ---------------------------------------to find the table------------------------------------------
func find_nearby_table() -> Node2D:
	var tables = get_tree().get_nodes_in_group("tables")
	for table in tables:
		if player.global_position.distance_to(table.global_position) < 64:  # Adjust as needed
			return table
	return null


func set_held(value: bool):
	held = value

# --------------------------------------change action name------------------------------------------
func _process(_delta):
	if held:
		var table = find_nearby_table()
		if table and table.can_drop_item():
			interaction_area.action_name = "[F] to place object on table"
		else:
			interaction_area.action_name = "[F] to drop object"
	else:
		interaction_area.action_name = item_name  # Default e.g. "Pick up"
