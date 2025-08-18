extends Control


signal option_selected(index: int)


# --- UI nodes ---
@onready var dialogue_label: Label = $CanvasLayer/DialogueLabel
@onready var options_box: VBoxContainer = $CanvasLayer/OptionsBox
@onready var buttons: Array[Button] = [
	$CanvasLayer/OptionsBox/Button,
	$CanvasLayer/OptionsBox/Button2,
	$CanvasLayer/OptionsBox/Button3
]

@onready var skip_button = $CanvasLayer/VBoxContainer/SkipButton
@onready var skip_all_button = $CanvasLayer/VBoxContainer/SkipAllButton
@onready var confirm_skip = $CanvasLayer/ConfirmSkip

@onready var next_indicator = $CanvasLayer/NextIndicator


# --- Dialogue state ---
var dialogue_active := false
var end_dialogue = false
var skip_confirmed = false
var current_dialogue_set = {}
var state = ""
var dialogue_task = null

# --- Dictionary containing all dialogue sets ---
var all_dialogue_sets = {
	"computer_amanda": {
		"game_start": {
			"lines": [
				"Oh. A Stranger!",
				"Got any questions?"
				],
			"options": [
				"I might need some help, O Mighty Amanda.",
				"Just a lil' troublemaker traversing around. Got some tips?",
				"AH! Talking computer!"
				],
			"next_states": ["help_oh_mighty_amanda", "tippy_tips", "talking_computer_what"]
		},
		
		"help_oh_mighty_amanda": {
			"lines": ["Help of what kind, exactly?"],
			"options": [
				"What... is my purpose here?",
				"Do you have any tips for me?"
				],
			"next_states": ["item_purpose", "item_tips"]
		},
		"tippy_tips": {
			"lines": ["Hmm. Have you tried picking up those spilled bottles over there?"],
			"options": [],
			"next_states": []
		},
		"talking_computer_what": {
			"lines": ["Yes, I am indeed capable of conversation.", "But don't let my sophistication intimidate you!"],
			"options": [],
			"next_states": []
		},
		
		"item_purpose": {
			"lines": [
				"Your purpose? To survive and explore!",
				"Everything else will reveal itself in time."
				],
			"options": [],
			"next_states": []
		}
	}
}


# -----------------------------the start of something so bright-------------------------------------
func _ready():
	$CanvasLayer.hide()
	next_indicator.hide()

	for i in range(buttons.size()):
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))
		
	options_box.hide()


# ----------------------------------which dialogue to use-------------------------------------------
func set_active_dialogue(item_key: String):
	if all_dialogue_sets.has(item_key):
		current_dialogue_set = all_dialogue_sets[item_key]
		state = current_dialogue_set.keys()[0]  # start at first state
	else:
		current_dialogue_set = {}
		state = ""


# ------------------------------the dialogue of the current state-----------------------------------
func _show_dialogue_state() -> void:
	if not current_dialogue_set.has(state):
		dialogue_active = false
		return

	dialogue_active = true
	var state_data = current_dialogue_set[state]

	await play_sequence(state_data.lines)

	if state_data.options.size() > 0:
		var choice = await show_options(state_data.options)
		state = _get_next_state(state, choice)
		await _show_dialogue_state()  # continue with new state
	else:
		dialogue_active = false
		$CanvasLayer.hide()


# ----------------------------------What's the Next State-------------------------------------------
func _get_next_state(current_state: String, choice_index: int) -> String:
	var state_data = current_dialogue_set.get(current_state)
	if state_data and choice_index < state_data.next_states.size():
		return state_data.next_states[choice_index]
	return current_state  # fallback if no next state


# ----------------------------------show lines in sequence------------------------------------------
func play_sequence(lines: Array) -> void:
	# Show everything first
	$CanvasLayer.show()
	
	for line in lines:
		if end_dialogue:
			break
		dialogue_label.text = str(line)
		await _wait_for_continue()


# -----------------------show the 'choice buttons' and wait for selection---------------------------
func show_options(options: Array) -> int:
	options_box.show()
	for i in range(buttons.size()):
		if i < options.size():
			buttons[i].text = str(options[i])
			buttons[i].show()
			buttons[i].disabled = false
		else:
			buttons[i].hide()

	var choice_index = await option_selected
	options_box.hide()
	return choice_index


# -------------------Wait for player to press a key or click to continue----------------------------
func _wait_for_continue() -> void:
	# To signal the player that there are still lines...
	next_indicator.show()
	
	var proceed = false
	while not proceed:
		await get_tree().process_frame
		if end_dialogue:
			break
		if Input.is_action_just_pressed("ui_accept"):
			proceed = true
	next_indicator.hide()


# --------------------------------handles button clicks---------------------------------------------
func _on_button_pressed(index: int):
	emit_signal("option_selected", index)


# -------------------------BUTTONS (i mean for skipping purposes)-----------------------------------
func _on_end_dialogue_button_pressed():
	confirm_skip.popup_centered()
	dialogue_active = true

func _on_confirm_skip_confirmed():
	end_dialogue = true
	skip_confirmed = true
	$CanvasLayer.hide()
