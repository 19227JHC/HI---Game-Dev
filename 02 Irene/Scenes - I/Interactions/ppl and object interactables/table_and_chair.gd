extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var slot_node = $PlacePoint  # Automatically gets the Marker2D named PlacePoint
@export var item_name: String = "Where's your key?"


var placed_item: Node2D = null
var player = null


func _ready():
	interaction_area.action_name = item_name
	
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found!")
	else:
		print("Player not found!")


# ----------to actively change the input keys in accordance to what it is in the InputMap-----------
func get_key_for_action(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		var ev = events[0]
		if ev is InputEventKey:
			return OS.get_keycode_string(ev.physical_keycode)  # shows actual key, e.g. "F"
		elif ev is InputEventMouseButton:
			return "Mouse" + str(ev.button_index)
	return action_name  # fallback if no key found


# -------------------------Allow placing any time; can customize if needed--------------------------
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


# --------------------------------------how the swapping happens------------------------------------
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


# -------------------------------for the door's requirements to open--------------------------------
func get_placed_item():
	return placed_item


# ----------------------------------interaction area's action name----------------------------------
func _process(delta):
	var interact_key = get_key_for_action("interact")

	if player.holding_item == false:
		interaction_area.action_name = item_name
	elif player.holding_item == true:
		interaction_area.action_name = "[" + interact_key + "] to place object"
