extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $StaticBody2D/AnimatedSprite2D
@onready var collision_shape = $StaticBody2D/CollisionShape2D


@export var item_name: String = "to pick up"
@export var carry_point_path: NodePath  # Drag your player's carry_point here


var held = false
var player = null
var carry_point = null


func _ready():
	# fly, keys, FLYYYY
	$StaticBody2D/AnimatedSprite2D.play("default")
	
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found!")
		carry_point = player.get_node("carry_point")
		print("Carry point: ", carry_point)
	else:
		print("Player NOT found!")
	
	if player.can_interact:
		# Set up the interaction behavior dynamically
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
			return OS.get_keycode_string(ev.physical_keycode)  # shows actual key, e.g. "F"
		elif ev is InputEventMouseButton:
			return "Mouse" + str(ev.button_index)
	return action_name  # fallback if no key found


# ---------------------------------------to find the table------------------------------------------
func find_door() -> Node2D:
	var doors = get_tree().get_nodes_in_group("good_door")
	if doors.size() == 0:
		return null

	var door = doors[0] as Node2D
	if player and player.global_position.distance_to(door.global_position) <= 64:
		return door
	return null


# --------------------------------to pick up and drop object----------------------------------------
func pickup_or_drop():
	if not held and carry_point:
		# Clear from table if was placed there
		var maybe_table = get_parent()
		if maybe_table and maybe_table.has_method("clear_placed_item"):
			maybe_table.clear_placed_item()

		# Disable collision
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
		var door = find_door()
		if door and door.can_accept_item(self):
			door.consume_key(self)  # door CONSUMES the key and the door (should) open
			return  # stop other drop logic cause the key is gone

		else:
			# drop to ground
			if player:
				get_parent().remove_child(self)
				player.get_parent().add_child(self)
				self.scale = Vector2(2, 2)
				
				var drop_offset = Vector2(32, 0)
				drop_offset = drop_offset.rotated(player.rotation)
				global_position = carry_point.global_position + drop_offset

		# Re-enable collision
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


# ------------------------------------are you holding anything?-------------------------------------
func set_held(value: bool):
	held = value

# yes, the key is being held by the player.
func is_held() -> bool:
	return held


# --------------------------------------change action name------------------------------------------
func _process(_delta):
	if not player:
		return

	var interact_key = get_key_for_action("interact")

	# If player CANNOT interact
	if not player.can_interact:
		# If is held, eject right away
		if held:
			eject()
			if player.has_method("set_held_item"):
				player.set_held_item(null)
			held = false

		# no interaction
		interaction_area.interact = Callable(self, "_do_nothing")
		interaction_area.action_name = ""
		return

	# If player CAN interact
	interaction_area.interact = Callable(self, "pickup_or_drop")
	if held:
		var door = find_door()
		if door:
			interaction_area.action_name = "[" + interact_key + "] to open door"
		else:
			interaction_area.action_name = "[" + interact_key + "] to drop object"
	else:
		interaction_area.action_name = "[" + interact_key + "] " + item_name

func _do_nothing():
	pass
