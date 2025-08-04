extends Node2D

@onready var slot_node = $PlacePoint  # Automatically gets the Marker2D named PlacePoint

var placed_item: Node2D = null

# Allow placing any time; can customize if needed
func can_drop_item() -> bool:
	return true

func place_item(item: Node2D):
	if not slot_node:
		push_error("slot_node is null! Make sure 'PlacePoint' exists under Table.")
		return

	if placed_item:
		swap_items(item)
	else:
		item.get_parent().remove_child(item)
		add_child(item)
		item.global_position = slot_node.global_position
		item.scale = Vector2(1, 1)  # Optional: adjust for table size
		placed_item = item

		if item.has_method("set_held"):
			item.set_held(false)

func swap_items(new_item: Node2D):
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("Player not found when swapping items.")
		return

	# Give old item to player
	remove_child(placed_item)
	var carry_point = player.get_node("carry_point")
	carry_point.add_child(placed_item)
	placed_item.position = Vector2.ZERO
	placed_item.scale = Vector2(1, 1)

	if placed_item.has_method("set_held"):
		placed_item.set_held(true)
	if player.has_method("set_held_item"):
		player.set_held_item(placed_item)

	# Place new item on table
	placed_item = new_item
	new_item.get_parent().remove_child(new_item)
	add_child(new_item)
	new_item.global_position = slot_node.global_position
	new_item.scale = Vector2(1, 1)

	if new_item.has_method("set_held"):
		new_item.set_held(false)
	if player.has_method("set_held_item"):
		player.set_held_item(null)

func clear_placed_item():
	placed_item = null
