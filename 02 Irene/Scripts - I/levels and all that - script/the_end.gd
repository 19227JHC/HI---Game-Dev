extends Node


@export var level_number = 2 # for the door logic


# SKIPS
@onready var skip_button = $CanvasLayer2/VBoxContainer/SkipButton
@onready var skip_all_button = $CanvasLayer2/VBoxContainer/SkipAllButton
@onready var confirm_skip = $CanvasLayer2/ConfirmSkip

# LABELS AND BUTTONS
@onready var dialogue_label = $CanvasLayer2/HSplitContainer/DialogueLabel
@onready var dialogue_label2 = $CanvasLayer2/HSplitContainer/DialogueLabel2
@onready var options_box = $CanvasLayer2/OptionsBox

# GLITCHES (and its toggle)
@onready var glitch_material := $CanvasLayer/Glitch.material as ShaderMaterial
@onready var glitch_toggle = $CanvasLayer2/GlitchToggle

# (☞ ͡° ͜ʖ ͡°)☞ NEXT ▶ indicator
@onready var next_indicator = $CanvasLayer2/NextIndicator
@onready var next_indicator2 = $CanvasLayer2/NextIndicator2


# buttons !!
var buttons = []

# skips
var skipping = false
var skip_all = false
var skip_confirmed = false

# starting state
var state = "start"

# the dialogue's job, I suppose
var dialogue_task = null

# glitches
var glitches_enabled: bool = true


func _ready():
	$AnimationPlayer.play("RESET")
	
	buttons = $CanvasLayer2/OptionsBox.get_children()
	for i in buttons.size():
		buttons[i].pressed.connect(func(): _on_button_pressed(i))
	show_dialogue()
	
	next_indicator.hide()
	glitch_toggle.toggled.connect(_on_glitch_toggle_toggled)
	# make sure it reflects current state
	glitch_toggle.button_pressed = glitches_enabled


#--------------------------------------do you want glitches?----------------------------------------
func _on_glitch_toggle_toggled(pressed: bool):
	glitches_enabled = pressed


#--------------------------------------------dialogues----------------------------------------------
func show_dialogue():
	if skip_all:
		start_game()
		return
	
	for button in buttons:
		button.hide()
		
	dialogue_task = call_deferred("_show_dialogue_state")


func _show_dialogue_state():
	pass
	#match state:


func _on_button_pressed(index):
	pass
	#match state:


func show_options(option_texts):
	if skip_confirmed:
		return  # Do not show options after skip all
	
	for i in range(buttons.size()):
		if i < option_texts.size():
			buttons[i].text = option_texts[i]
			buttons[i].show()
		else:
			buttons[i].hide()


#----------------------------------------play sequence----------------------------------------------
# Words that'll trigger the glitch
var glitch_keywords = [
	"player",
	"thank you",
	"cruel",
	"karma",
	"unknown disease",
	"dying"
]

func play_sequence(lines, force := false):
	for line in lines:
		# For Skip and Skip All
		if skip_all and not force:
			break
			
		if skipping and not force:
			# Instantly set the line without waiting for input
			dialogue_label.text = line
			await get_tree().create_timer(0.1).timeout
			continue

		# Check if line contains any glitch-trigger keyword
		var triggered = false
		for keyword in glitch_keywords:
			if line.to_lower().contains(keyword):
				triggered = true
				break

		# Check if the player wants glitches
		#if triggered and glitches_enabled:
			#await trigger_glitch()

		dialogue_label.text = line
		
		# Only wait if NOT skipping
		if not skipping or force:
			await _wait_for_continue()
		# await get_tree().create_timer(2).timeout
		
	skipping = false  # reset skipping flag here


#---------------------------press a key or click to go to next line---------------------------------
func _wait_for_continue():
	if not is_inside_tree():
		return
		
	next_indicator.show()

	var proceed = false
	while not proceed:
		await get_tree().create_timer(0.01).timeout

		# If skip_all is triggered elsewhere, break immediately
		if skip_all:
			break

		# If skipping is active, break immediately
		if skipping:
			break

		# Normal advance: Space/Enter/Click
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("mouse_left"):
			proceed = true

	next_indicator.hide()


#----------------------------------on [what] button pressed-----------------------------------------
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

	start_game()
	

#---------------------------so logic is logic-ing for confirm skip----------------------------------
func start_game():
	for button in buttons:
		button.hide()
	
	skip_confirmed = false
	
	# Say thank you, guys
	$CanvasLayer3/PanelContainer.show()
	$AnimationPlayer.play("blur")
	
	await get_tree().create_timer(2.5).timeout
	
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/level_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
