extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

@export var item_name: String = "to pick up"
@export var carry_point_path: NodePath  # Drag your player's carry_point here

var held: bool = false
var player: Node = null
var carry_point: Node = null


func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found!")
		carry_point = player.get_node("carry_point")
		print("Carry point: ", carry_point)
	else:
		print("Player NOT found!")

	# Set up the interaction behavior dynamically
	if player and player.can_interact:
		interaction_area.action_name = item_name
		interaction_area.interact = Callable(self, "pickup_or_drop")
	else:
		eject()


# ----------to actively change the input keys in accordance to what it is in the InputMap-----------
func get_key_for_action(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		var ev = events[0]
		if ev is InputEventKey:
			return OS.get_keycode_string(ev.physical_keycode)
		elif ev is InputEventMouseButton:
			return "Mouse" + str(ev.button_index)
	return action_name


# --------------------------------to pick up and drop object----------------------------------------
func pickup_or_drop():
	if not held and carry_point:
		# Clear from table if was placed there
		var maybe_table = get_parent()
		if maybe_table and maybe_table.has_method("clear_placed_item"):
			maybe_table.clear_placed_item()

		# Disable collision when held
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
			# temp. disable collision shape becuz it kept on pushing the player and i kept on forgetting to change it
			collision_shape.disabled = true

			# Place or swap
			table.place_item(self)

			# re-enable it
			collision_shape.disabled = false
		else:
			# Drop to ground
			if player:
				get_parent().remove_child(self)
				player.get_parent().add_child(self)
				self.scale = Vector2(2, 2)

				# Drop slightly in front of the player so it doesn't overlap their collision
				var drop_offset = Vector2(32, 0)
				drop_offset = drop_offset.rotated(player.rotation)
				global_position = carry_point.global_position + drop_offset

		# Re-enable collision when dropped or placed
		collision_shape.disabled = false
		held = false

		if player and player.has_method("set_held_item"):
			player.set_held_item(null)


# forcibly eject
func eject():
	if player:
		if player.has_method("set_held_item"):
			player.set_held_item(null)
		held = false

		get_parent().remove_child(self)
		player.get_parent().add_child(self)
		self.scale = Vector2(2, 2)

		var drop_offset = Vector2(32, 0)
		drop_offset = drop_offset.rotated(player.rotation)
		global_position = carry_point.global_position + drop_offset


# ---------------------------------------to find the table------------------------------------------
func find_nearby_table() -> Node2D:
	var tables = get_tree().get_nodes_in_group("tables")
	for table in tables:
		if player.global_position.distance_to(table.global_position) < 64:
			return table
	return null


func set_held(value: bool):
	held = value


# --------------------------------------change action name------------------------------------------
func _process(_delta):
	if not player:
		return

	var interact_key = get_key_for_action("interact")

	# If player CANNOT interact
	if not player.can_interact:
		if held:
			eject()
			if player.has_method("set_held_item"):
				player.set_held_item(null)
			held = false

		interaction_area.interact = Callable(self, "_do_nothing")
		interaction_area.action_name = ""
		return

	# If player CAN interact
	interaction_area.interact = Callable(self, "pickup_or_drop")
	if held:
		var table = find_nearby_table()
		if table:
			interaction_area.action_name = "[" + interact_key + "] to drop on table"
			if table.placed_item:
				interaction_area.action_name = "[" + interact_key + "] swap objects"
		else:
			interaction_area.action_name = "[" + interact_key + "] to drop object"
	else:
		interaction_area.action_name = "[" + interact_key + "] " + item_name


func _do_nothing():
	pass
