extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialogue_manager = $dialogue  # This should be your InteractableDialogue node


var dialogue_task = null
var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")

	var interact_key = get_key_for_action("interact")
	interaction_area.action_name = "[" + interact_key + "] to interact"
	interaction_area.interact = Callable(self, "_on_item_interacted")


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


# ------------------------------------ITEM INTERACTION----------------------------------------------
func _on_item_interacted():
	get_tree().paused = true
	
	$dialogue/CanvasLayer.show() # just in case?
	
	dialogue_manager.set_active_dialogue("skeleton_statue")
	await dialogue_manager._show_dialogue_state()


# -------------------------------------RUN DIALOGUE-------------------------------------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()
