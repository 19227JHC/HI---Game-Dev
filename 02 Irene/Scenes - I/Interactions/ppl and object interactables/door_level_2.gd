extends Node2D


@export var destination_position: Vector2

@onready var interaction_area: InteractionArea = $InteractionArea


var player = null
var key = null
var key_is_consumed := false
var item_name: String = "Talk to the statue first."
var my_statue = null


func _ready():
	my_statue = get_tree().get_first_node_in_group("skeleton_statue")
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.action_name = item_name

	player = get_tree().get_first_node_in_group("player")
	if player:
		print("Player found!")
	else:
		print("Player NOT found!")


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


# ------------------------------------------key? key? key?------------------------------------------
func can_accept_item(item) -> bool:
	return item.is_in_group("key")  # only accepts keys


# ---------------------------------------PLACE YOUR OFFERINGG---------------------------------------
func consume_key(item):
	# Consume the key
	item.set_held(false)
	if player:
		player.set_held_item(null)
	item.queue_free()
	
	key_is_consumed = true


# -----------------------------------------key requirement------------------------------------------
func key_on_hand() -> bool:
	if player and player.has_method("get_held_item"):
		var held_item = player.get_held_item()
		if held_item and held_item.is_in_group("key"):
			return true
	return false


# OPEN SESAME
func open_door():
	$StaticBody2D/AnimatedSprite2D.play("open")
	if player:
		player.start_room_transition(destination_position, self)
	
	# Remove the key the player is holding and CONSUME it
	var held_item = player.get_held_item()
	if held_item and held_item.is_in_group("key"):
		player.set_held_item(null)
		held_item.call_deferred("queue_free")


# -------------------------------------------ON INTERACT--------------------------------------------
func _on_interact() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	# or gobal.bad_moral_points == 0 -> put out just for testing!!
	if gobal.good_moral_points >= 7 or key_is_consumed == true:
		open_door()
	else:
		print("You Shall Not Pass.")


# ----------------------------------------change item name------------------------------------------
# player talk to statue, statue emit signal, door get signal, and this is the function where
# the door changes its action_name so the player knows they know can enter now!
func change_action_name():
	var interact_key = get_key_for_action("interact")
	interaction_area.action_name = "[" + interact_key + "] to enter"


# don't think i'll need it anymore because of the signal thing
func _process(delta):
	# or gobal.bad_moral_points == 0 -> put out just for testing!!
	if key_is_consumed == true:
		var interact_key = get_key_for_action("interact")
		interaction_area.action_name = "[" + interact_key + "] to enter"
	#else:
		#interaction_area.action_name = item_name
	pass
