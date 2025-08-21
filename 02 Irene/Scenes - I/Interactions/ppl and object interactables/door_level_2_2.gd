extends Node2D


@export var destination_position: Vector2


@onready var interaction_area: InteractionArea = $InteractionArea


var item_name: String = "🧙‍♂️\nYOU SHALL NOT PASS."


func _ready():
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


# -------------------------------------------ON INTERACT--------------------------------------------
func _on_interact() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and gobal.bad_moral_points >= 2:
		$StaticBody2D/AnimatedSprite2D.play("open")
		player.start_room_transition(destination_position, self)


func _process(delta):
	if gobal.bad_moral_points >= 2:
		var interact_key = get_key_for_action("interact")
		interaction_area.action_name = "[" + interact_key + "] to enter"
	else:
		interaction_area.action_name = item_name
