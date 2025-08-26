extends Node2D


@export var destination_position: Vector2


@onready var interaction_area: InteractionArea = $InteractionArea


var item_name: String = "Talk to the statue first."
var my_statue = null


func _ready():
	interaction_area.action_name = item_name
	
	my_statue = get_tree().get_first_node_in_group("naked_statue")
	my_statue.changeActionName.connect(change_action_name)
	
	interaction_area.interact = Callable(self, "_on_interact")


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


# ----------------------------------------change item name------------------------------------------
# player talk to statue, statue emit signal, door get signal, and this is the function where
# the door changes its action_name so the player knows they know can enter now!
func change_action_name():
	var interact_key = get_key_for_action("interact")
	interaction_area.action_name = "[" + interact_key + "] to enter"


# -------------------------------------------ON INTERACT--------------------------------------------
func _on_interact() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and gobal.bad_moral_points >= 2:
		$StaticBody2D/AnimatedSprite2D.play("open")
		player.start_room_transition(destination_position, self)


# yeah don't think i'll use it; this is for 'just in case's
func _process(delta):
	#if gobal.bad_moral_points >= 2:
		#var interact_key = get_key_for_action("interact")
		#interaction_area.action_name = "[" + interact_key + "] to enter"
	#else:
		#interaction_area.action_name = item_name
	pass
