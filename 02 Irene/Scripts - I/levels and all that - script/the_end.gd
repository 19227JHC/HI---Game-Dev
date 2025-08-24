extends Node


signal option_selected(index: int)


# SKIPS
@onready var skip_button = $CanvasLayer2/VBoxContainer/SkipButton
@onready var skip_all_button = $CanvasLayer2/VBoxContainer/SkipAllButton
@onready var confirm_skip = $CanvasLayer2/ConfirmSkip

# LABELS AND BUTTONS
@onready var dialogue_label1: RichTextLabel = $CanvasLayer2/HSplitContainer/PanelContainer/CenterContainer/DialogueLabel
@onready var dialogue_label2: RichTextLabel = $CanvasLayer2/HSplitContainer/PanelContainer2/CenterContainer2/DialogueLabel2
@onready var options_box: VBoxContainer = $CanvasLayer2/OptionsBox
@onready var buttons: Array[Button] = [
	$CanvasLayer2/OptionsBox/Button,
	$CanvasLayer2/OptionsBox/Button2,
	$CanvasLayer2/OptionsBox/Button3
]

# GLITCHES (and its toggle)
@onready var glitch_material := $CanvasLayer/Glitch.material as ShaderMaterial
@onready var glitch_toggle = $CanvasLayer2/GlitchToggle

# (☞ ͡° ͜ʖ ͡°)☞ NEXT ▶ indicator
@onready var next_indicator1 = $CanvasLayer2/NextIndicator
@onready var next_indicator2 = $CanvasLayer2/NextIndicator2


# the state of the dialogue; is it continuing or is it skipped, etc.
# skips
var skipping = false
var skip_all = false
var skip_confirmed = false

# NOT the match state in the dialogue set.
var dialogue_active := false
var end_dialogue = false
var dialogue_task = null

# dialogue data
var current_dialogue_set = {}

# to track current dialogue state
var state = ""

# to find last state
var active_dialogue: String = ""
var current_state: String = ""
var last_state: String = "" # --> to keep track of the FINAL state

# glitches
var glitches_enabled: bool = true


# because we'll have three, HA!
enum Speakers {
	H,
	I
}


# for the richlabel teext (bbcode)
var big_words = 32

# now to store all the dialogues...
var all_dialogues_set = DialogueSetsManager.all_endings_dialogues_set


# ------------------------------------------level on ready------------------------------------------
func _ready():
	next_indicator1.hide()
	next_indicator2.hide()
	options_box.hide()

	for i in range(buttons.size()):
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))

	set_active_dialogue("intro")
	start_dialogue()


#--------------------------------------do you want glitches?----------------------------------------
func _on_glitch_toggle_toggled(pressed: bool):
	glitches_enabled = pressed


# set active dialogue
func set_active_dialogue(key: String):
	if all_dialogues_set.has(key):
		active_dialogue = key
		current_dialogue_set = all_dialogues_set[key]
		current_state = current_dialogue_set.keys()[0]


#--------------------------------------------dialogues----------------------------------------------
func start_dialogue() -> void:
	if not is_inside_tree():
		return
	await _show_dialogue_state()

func _show_dialogue_state() -> void:
	if current_state == "":
		return

	var state_data = current_dialogue_set[current_state]

	# show lines
	for entry in state_data.get("lines", []):
		_set_dialogue(entry)
		await _wait_for_continue()

	# handle options
	if state_data.has("options") and state_data.options.size() > 0:
		var choice_index = await show_options(state_data.options)
		current_state = state_data.next_states[choice_index]
		await _show_dialogue_state()
	elif state_data.has("next_states") and state_data.next_states.size() > 0:
		current_state = state_data.next_states[0]
		await _show_dialogue_state()
	else:
		last_state = current_state
		$CanvasLayer2.hide()
		get_tree().paused = false


#----------------------------------------dialogue logic---------------------------------------------
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


#----------------------------------------play sequence----------------------------------------------
# Words that'll trigger the glitch
var glitch_keywords = [
	"player",
	"#others"
]

func play_sequence(lines, force := false):
	for entry in lines:
		if skip_all and not force:
			break
			
		if skipping and not force:
			_set_dialogue(entry)
			await get_tree().create_timer(0.1).timeout
			continue

		# Handle glitches if needed
		var triggered = false
		for keyword in glitch_keywords:
			if entry.line.to_lower().contains(keyword):
				triggered = true
				break
		if triggered and glitches_enabled:
			await trigger_glitch()

		# Actually show the line in the correct label
		_set_dialogue(entry)

		# Wait for input
		if not skipping or force:
			await _wait_for_continue()
	
	skipping = false

# ----------------------SET DIALOGUE TEXT BASED ON SPEAKER-------------------------
func _set_dialogue(entry: Dictionary) -> void:
	# clear and hide them first
	dialogue_label1.text = ""
	dialogue_label2.text = ""
	next_indicator1.hide()
	next_indicator2.hide()

	match entry.speaker:
		Speakers.H:
			dialogue_label1.text = "[center]" + entry.line + "[/center]"
			next_indicator1.show()
		Speakers.I:
			dialogue_label2.text = "[center]" + entry.line + "[/center]"
			next_indicator2.show()



#---------------------------press a key or click to go to next line---------------------------------
func _wait_for_continue() -> void:
	var proceed = false
	while not proceed:
		await get_tree().create_timer(0.01).timeout
		if end_dialogue:
			break
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("mouse_left"):
			proceed = true

	# Hide indicators after player continues
	next_indicator1.hide()
	next_indicator2.hide()


#----------------------------------on [what] button pressed-----------------------------------------
func _on_button_pressed(index: int):
	emit_signal("option_selected", index)

func _on_skip_button_pressed():
	skipping = true

func _on_skip_all_button_pressed():
	confirm_skip.popup_centered()

func _on_confirm_skip_confirmed():
	skip_all = true
	skip_confirmed = true

	# Hide all buttons
	for button in buttons:
		button.hide()

	endgame()
	

#---------------------------so logic is logic-ing for confirm skip----------------------------------
func endgame():
	for button in buttons:
		button.hide()
	
	skip_confirmed = false
	
	await get_tree().create_timer(2.5).timeout
	
	# reset things cuz you're done!
	gobal.reset()
	
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")


#-------------------------------------------glitches------------------------------------------------
func trigger_glitch():
	glitch_material.set_shader_parameter("glitch_active", true)
	glitch_material.set_shader_parameter("shake_rate", 1.0)
	glitch_material.set_shader_parameter("shake_power", 0.05)
	#glitch_sound.play()

	await get_tree().create_timer(0.5).timeout

	glitch_material.set_shader_parameter("glitch_active", false)
	glitch_material.set_shader_parameter("shake_rate", 0.0)
	glitch_material.set_shader_parameter("shake_power", 0.0)
