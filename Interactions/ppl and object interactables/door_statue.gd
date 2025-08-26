extends Node2D


signal healthChanged # 4 health bar


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D
@onready var dialogue_manager = $dialogue

# for that one string of choices
@onready var options_box: VBoxContainer = $dialogue/CanvasLayer/OptionsBox
@onready var buttons: Array[Button] = [
	$dialogue/CanvasLayer/OptionsBox/Button,
	$dialogue/CanvasLayer/OptionsBox/Button2,
	$dialogue/CanvasLayer/OptionsBox/Button3,
	$dialogue/CanvasLayer/OptionsBox/Button4
]


# for tables
@export var tables: Array[NodePath] = [
	NodePath("../table_and_chair"),
	NodePath("../table_and_chair2"),
	NodePath("../table_and_chair3")
]


var player = null
var key_is_consumed := false


func _ready():
	player = get_tree().get_first_node_in_group("player")
	interaction_area.interact = Callable(self, "_on_item_interacted")
	dialogue_manager.connect("option_selected", Callable(self, "_on_dialogue_option_selected"))
	
	# forcibly hide everything before it comes up
	$CanvasLayer.hide()
	$ThanksForThePayment.hide()
	$RegretfullyNo.hide()
	$AnimationPlayer.play("RESET")


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
	
	if not required_items_placed() and not key_is_consumed:
		# have to do place the keys first
		dialogue_manager.set_active_dialogue("not_yet_door_statue")
		await dialogue_manager._show_dialogue_state()
		match dialogue_manager.last_state:
			"real_nice_of_you":
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/good_ending.tscn")
	if key_is_consumed:
		# technically can leave because of the key, but world isn't saved yet.
		dialogue_manager.set_active_dialogue("key_found_door_statue")
		await dialogue_manager._show_dialogue_state()
		match dialogue_manager.last_state:
			"anytime":
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/good_ending.tscn")
			"to_save_this_world":
				pass
	if required_items_placed():
		# world is saved, WOO HOOO! you may leave freely.
		dialogue_manager.set_active_dialogue("solved_puzzle_door_statue")
		await dialogue_manager._show_dialogue_state()
		match dialogue_manager.last_state:
			"is_this_the_end":
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/good_ending.tscn")


# -------------------------------------requirements to leave----------------------------------------
func required_items_placed() -> bool:
	var resolved_tables = []
	for path in tables:
		var node = get_node_or_null(path)
		if node:
			resolved_tables.append(node)

	# Safety net
	if resolved_tables.size() < 3:
		return false

	var table1 = resolved_tables[0]
	var table2 = resolved_tables[1]
	var table3 = resolved_tables[2]

	var item1 = table1.get_placed_item()
	var item2 = table2.get_placed_item()
	var item3 = table3.get_placed_item()

	return item1 and item1.name in ["It_s_Chemical", "It_s_Chemical2", "It_s_Chemical3"] \
		and item2 and item2.name == "chemical_bottle6" \
		and item3 and item3.name in ["It_s_Chemical", "It_s_Chemical2", "It_s_Chemical3"]


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


# --------------------------------------RUN DIALOGUE - backup---------------------------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()


# HERE FOR CHANGE HEALTH THING
func _on_dialogue_option_selected(index: int) -> void:
	var state = dialogue_manager.current_state

	if state != "how_much":
		return

	var state_data = dialogue_manager.current_dialogue_set[state]
	var available_options = []

	# Only show options the player can afford
	for i in range(state_data.options.size()):
		match i:
			0:  # 5 health
				if player.currentHealth >= 5:
					available_options.append(i)
			1:  # 10 health
				if player.currentHealth >= 10:
					available_options.append(i)
			2:  # 20 health
				if player.currentHealth >= 20:
					available_options.append(i)
			3:  # Never mind is always available
				available_options.append(i)

	# If the selected index is not available (player clicked a hidden option), ignore
	if index not in available_options:
		return

	# Deduct health if applicable
	match index:
		0:
			player.currentHealth -= 5
		1:
			player.currentHealth -= 10
		2:
			player.currentHealth -= 20
		3:
			pass  # Never mind

	player.healthChanged.emit()

	# Go to the next state based on the choice
	dialogue_manager.current_state = state_data.next_states[index]


# --------------------------------------change action name------------------------------------------
func _process(_delta):
	if not player:
		return

	var interact_key = get_key_for_action("interact")

	if not required_items_placed() or key_is_consumed:
		interaction_area.action_name = "[" + interact_key + "] for instructions"
	if key_is_consumed:
		interaction_area.action_name = "[" + interact_key + "] to talk.\nAlmost there!"
	if required_items_placed():
		interaction_area.action_name = "[" + interact_key + "] to talk.\nYou're done!!"
