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

# ------------------------------------------VARIABLES-----------------------------------------------
# the state of the dialogue; is it continuing or is it skipped, etc.
# NOT the match state in the dialogue set.
var dialogue_active := false
var end_dialogue = false
var skip_confirmed = false
var dialogue_task = null

# dialogue data
var current_dialogue_set = {}

# to track current dialogue state
var state = ""

# to find last state
var active_dialogue: String = ""
var current_state: String = ""
var last_state: String = "" # --> to keep track of the FINAL state

# --------------------------------All the dialogues stored here-------------------------------------
var all_dialogue_sets = {
	"computer_amanda": {
		"start": {
			"lines": [
				"Oh. A Stranger!",
				"Got any questions?"
			],
			"options": [
				"I might need some help, O Mighty Amanda.",
				"Just a lil' troublemaker traversing around. Got some tips?",
				"AH! Talking computer!"
			],
			"next_states": ["help_me_o_mighty_one", "tippy_tricks", "ah_talking_computer"]
		},

		# help me o mighty one!
		"help_me_o_mighty_one": {
			"lines": [
				"Help of what kind, exactly?"
			],
			"options": [
				"What is my purpose here?",
				"Do you have any tips for me?"
			],
			"next_states": ["purpose_what_purpose", "tippy_tricks"]
		},

		# purpose? what purpose?
		"purpose_what_purpose": {
			"lines": [
				"To save this world and its inhabitants-",
				"Hold on, were you not informed?"
			],
			"options": [
				"I kinda just jumped in.",
				"I was, it's just that I'm still confused."
			],
			"next_states": ["the_chosen_one", "the_chosen_one"]
		},
		"the_chosen_one": {
			"lines": [
				"In that case, like I said before, YOU were chosen to save this world.",
				"Though only the higher powers can answer WHY you were chosen, I'd say that you're not a really bad choice."
			],
			"options": [
				"What about you, then?",
				"That's... surprisingly nice to hear."
			],
			"next_states": ["i_am_good_how_about_you", "nice_to_hear"]
		},
		"i_am_good_how_about_you": {
			"lines": ["Me?"],
			"options": ["Yeah. Why are you here?"],
			"next_states": ["why_you_here"]
		},
		"nice_to_hear": {
			"lines": ["Haha! Glad I can be of help."],
			# immediately goes to next line (the next state)
			"next_states": ["see_you_ending"]
		},

		# the trickster path
		"tippy_tricks": {
			"lines": ["Hmm. Have you tried picking up those spilled bottles over there?"],
			"options": ["Yes", "No"],
			"next_states": ["tried_the_bottles", "no_try_bottles"]
		},
		"tried_the_bottles": {
			"lines": ["That's good!"],
			# immediately goes to next line (the next state)
			"next_states": ["no_try_bottles"]
		},
		"no_try_bottles": {
			"lines": ["What about the tables? They may just contain the key out of this room."],
			"options": [
				"No, but I will.",
				"Have you got any other tips?"
			],
			"next_states": ["see_you_ending", "other_tips"]
		},
		"other_tips": {
			"lines": [
				"My school was once filled with students and teachers.",
				"Now all that's left are... hollow shells of our former selves.",
				"I beg you to never forget their past.",
				"They aren't just the monsters you may think they are..."
			],
			"options": ["Of course. You have my word."],
			"next_states": ["see_you_ending"]
		},

		# AH! TALKING COMPUTER?!
		"ah_talking_computer": {
			"lines": ["Oho, never seen one before? Worry not, I’m not just a talking computer, I’m an intelligent talking computer."],
			"options": [
				"Where did you even come from?!",
				"Oh, okay then... You got any tips?"
			],
			"next_states": ["why_you_here", "tippy_tricks"]
		},
		"why_you_here": {
			"lines": ["Technology. My life's tethered to this place. But... without the people maintaining me, I'm as good as dead."],
			"options": [
				"Is there... any way for me to help you?",
				"But who are 'the people'? Is it-Oh, the zombies?"
			],
			"next_states": ["to_help_you", "the_people"]
		},
		"the_people": {
			"lines": ["Yes. Be careful of what you do with them. They were once human, after all."],
			"options":[
				"Ah, of course.",
				"Might you have any other tips?",
				"But would there be any way I can be of any help to you?"
			],
			"next_states": ["see_you_ending", "tippy_tricks", "to_help_you"]
		},
		"to_help_you": {
			"lines": ["Help... me?", "You truly want to... help me?"],
			"options": [
				"Yeah, of course!",
				"Pfft- You fell for that? Sorry, but inanimate objects don't have feelings!"
			],
			"next_states": ["really_help", "cruel_ending"]
		},
		"really_help": {
			"lines": [
				"Well that's very nice of you.",
				"The only way would be to... give me half of your life to set my soul free."
			],
			"options": [
				"I- Right. Equivalent exchange. Large price for a large wish. I... will.",
				"What? No!"
			],
			"next_states": ["great_ending", "cruel_ending"]
		},

		# endings
		"see_you_ending": {
			"lines": ["Then I shall see you around, Player."]
		},
		"great_ending": {
			# AAAND the player loses 1/2 health. Literally. But mora points + 20, a guaranteed entry to the 'good ending' in level 2.
			"lines": [
				"Thank you, Player. I will never forget this.",
				"Here's a tip for you. Think twice when choosing the right path.",
				"Goodbye now. May you find a way out of this hellhole."
			]
		},
		"cruel_ending": {
			"lines": [
				"There's always a steep price behind every choice.",
				"You are cruel, Player. I regret ever putting my hopes on you.",
				"Goodbye."
				]
			# AAAND the player loses 1/2 health, not the literal kind, unfortunately. Also -5 moral points.
		}
	}
	
	# other item interactions can be stored here :D
}


# -----------------------------the start of something so bright-------------------------------------
func _ready():
	$CanvasLayer.hide()
	next_indicator.hide()

	for i in range(buttons.size()):
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))
		
	options_box.hide()
	
	start_dialogue()

func start_dialogue() -> void:
	if not is_inside_tree():
		return
	await _show_dialogue_state()


# ----------------------------------which dialogue to use-------------------------------------------
func set_active_dialogue(item_key: String):
	if all_dialogue_sets.has(item_key):
		active_dialogue = item_key
		current_dialogue_set = all_dialogue_sets[item_key]
		# start at first state of this dialogue set
		current_state = current_dialogue_set.keys()[0]
	else:
		active_dialogue = ""
		current_dialogue_set = {}
		current_state = ""


# ------------------------------the dialogue of the current state-----------------------------------
func _show_dialogue_state() -> void:
	if active_dialogue == "" or not all_dialogue_sets.has(active_dialogue):
		return

	var dialogue = all_dialogue_sets[active_dialogue]

	if not dialogue.has(current_state):
		return

	var state_data = dialogue[current_state]

	# show lines
	for line in state_data.get("lines", []):
		dialogue_label.text = line
		await _wait_for_continue()

	# check for options
	if state_data.has("options") and state_data.options.size() > 0:
		var choice_index = await show_options(state_data.options)
		current_state = state_data.next_states[choice_index]
		await _show_dialogue_state()
	elif state_data.has("next_states"):
	# no options, just auto-pick the first next state
		current_state = state_data.next_states[0]
		await _show_dialogue_state()
	else:
		 # no next states → end dialogue
		last_state = current_state
		$CanvasLayer.hide()
		get_tree().paused = false
		



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
	if not is_inside_tree():
		return

	# To signal the player that there are still lines...
	next_indicator.show()
	var proceed = false
	while not proceed:
		await get_tree().create_timer(0.001).timeout
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
	
	get_tree().paused = false
