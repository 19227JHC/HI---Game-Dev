extends Control


signal option_selected(index: int) # for the option choosen


# --- UI nodes ---
@onready var dialogue_label: Label = $CanvasLayer/DialogueLabel
@onready var options_box: VBoxContainer = $CanvasLayer/OptionsBox
@onready var buttons: Array[Button] = [
	$CanvasLayer/OptionsBox/Button,
	$CanvasLayer/OptionsBox/Button2,
	$CanvasLayer/OptionsBox/Button3,
	$CanvasLayer/OptionsBox/Button4
]

@onready var confirm_skip = $CanvasLayer/ConfirmSkip

@onready var next_indicator = $CanvasLayer/NextIndicator


var option_index_map: Array[int] = []


# ------------------------------------------VARIABLES-----------------------------------------------
var player = null

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

# All the dialogues stored here
var all_dialogue_sets = DialogueSetsManager.all_interaction_dialogue_sets


# -----------------------------the start of something so bright-------------------------------------
func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		print("player for dialogue found")
	else:
		print("player for dialogue NOT found!!")

	$CanvasLayer.hide()
	next_indicator.hide()

	for i in range(buttons.size()):
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))
		
	options_box.hide()
	
	start_dialogue()

func start_dialogue() -> void:
	# If dialogue ended early, just bail out
	#canceled because i'm not using the end dialogue button no more
	#if end_dialogue:
		#InteractionManager.can_interact = true
		#end_dialogue = false
		#dialogue_active = false # added this
			# Cancel running dialogue coroutine if tracked
		#if dialogue_task:
		#	dialogue_task = null
		#return

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
	# If dialogue ended early, just bail out
	#canceled because i'm not using the end dialogue button no more
	#if end_dialogue:
		#InteractionManager.can_interact = true
		#end_dialogue = false
		#dialogue_active = false # added this
			# Cancel running dialogue coroutine if tracked
		#if dialogue_task:
		#	dialogue_task = null
		#return

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
		
	#elif dialogue == "solved_puzzle_door_statue":
		#if current_state == "sacrificial_option":
			#restart()
			
	elif state_data.has("next_states"):
	# no options, just auto-pick the first next state
	# I'll try not to rely on this too much; the logic makes more sense to me if I write it
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
		#canceled because i'm not using the end dialogue button no more
		#if end_dialogue:
			#break
		dialogue_label.text = str(line)
		await _wait_for_continue()


# -----------------------show the 'choice buttons' and wait for selection---------------------------
func show_options(options: Array) -> int:
	options_box.show()

	# Reset all buttons hidden
	for b in buttons:
		b.hide()
		b.disabled = true
		b.set_meta("real_index", null)

	option_index_map.clear()

	# Build visible list (filter for "how_much")
	var btn_slot := 0
	for i in range(options.size()):
		var show_button := true
		
		if active_dialogue == "not_yet_door_statue" and current_state == "how_much":
			var hp = player.currentHealth
			match i:
				0: show_button = hp >= 5    # the five
				1: show_button = hp >= 10   # the ten
				2: show_button = hp >= 20   # the twenty
				3: show_button = true       # “Never mind”

		if show_button and btn_slot < buttons.size():
			var btn := buttons[btn_slot]
			btn.text = str(options[i])
			btn.show()
			btn.disabled = false
			btn.set_meta("real_index", i)   # map back to real option index
			option_index_map.append(i)
			btn_slot += 1

	# Wait for a click on any visible button
	var choice_index = await self.option_selected
	options_box.hide()
	return int(choice_index)


# -------------------Wait for player to press a key or click to continue----------------------------
func _wait_for_continue() -> void:
	if not is_inside_tree():
		return
		
	# If dialogue ended early, just bail out
	#canceled because i'm not using the end dialogue button no more
	#if end_dialogue:
		#InteractionManager.can_interact = true
		#end_dialogue = false
		#return
		
	# To signal the player that there are still lines...
	next_indicator.show()
	var proceed = false
	while not proceed:
		await get_tree().create_timer(0.001).timeout
		# canceled becuz no more end dialogue button
		#if end_dialogue:
			#break
		if Input.is_action_just_pressed("ui_accept"):
			proceed = true
	next_indicator.hide()


# --------------------------------handles button clicks---------------------------------------------
func _on_button_pressed(index: int):
	$press.play() # plays sound when button is pressed - HANNAH
	emit_signal("option_selected", index)


# -------------------------BUTTONS (i mean for skipping purposes)-----------------------------------
# decided not to have one :))


# --------------------------------- HANNAH ------------------------------------
# player options hover
func _on_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button

func _on_button_2_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button

func _on_button_3_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button.

func _on_button_4_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button.
