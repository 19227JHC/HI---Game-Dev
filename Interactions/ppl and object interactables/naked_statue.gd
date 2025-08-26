extends Node2D


signal changeActionName # for the door


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D
@onready var dialogue_manager = $dialogue


var dialogue_task = null
var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")
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
	#get_tree().paused = true
	
	$dialogue/CanvasLayer.show() # just in case?
	
	# canNOT enter !!
	if gobal.good_moral_points >= 1 and gobal.bad_moral_points == 0:
		dialogue_manager.set_active_dialogue("naked_statue_too_good")
		await dialogue_manager._show_dialogue_state()
	elif gobal.good_moral_points == 0 and gobal.bad_moral_points == 0:
		# if you've done NOTHING AT. ALL.
		dialogue_manager.set_active_dialogue("naked_statue_meh")
		await dialogue_manager._show_dialogue_state()
	# CAN enter!
	elif gobal.bad_moral_points >= 3:
		dialogue_manager.set_active_dialogue("naked_statue_evil_enough")
		await dialogue_manager._show_dialogue_state()
		changeActionName.emit()
	else:
		# if you've done what you needed to do to leave (aka killed at least one of the enemies)
		dialogue_manager.set_active_dialogue("naked_statue_just_enough")
		await dialogue_manager._show_dialogue_state()
		changeActionName.emit()


# -------------------------------------RUN DIALOGUE-------------------------------------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()


func _process(delta):
	var interact_key = get_key_for_action("interact")
	interaction_area.action_name = "[" + interact_key + "] to interact"
