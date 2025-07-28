extends Node

@onready var skip_button = $CanvasLayer2/VBoxContainer/SkipButton
@onready var skip_all_button = $CanvasLayer2/VBoxContainer/SkipAllButton
@onready var confirm_skip = $CanvasLayer2/ConfirmSkip

@onready var dialogue_label = $CanvasLayer2/DialogueLabel
@onready var options_box = $CanvasLayer2/OptionsBox

@onready var glitch_material := $CanvasLayer/Glitch.material as ShaderMaterial
@onready var glitch_sound := $GlitchRect/GlitchSound

var buttons = []

var skipping = false
var skip_all = false

var state = "start"
var moral_points = 0

func _ready():
	buttons = $CanvasLayer2/OptionsBox.get_children()
	for i in buttons.size():
		buttons[i].pressed.connect(func(): _on_button_pressed(i))
	show_dialogue()

#--------------------------------------------dialogues----------------------------------------------
func show_dialogue():
	if skip_all:
		start_game()
		return
	
	for button in buttons:
		button.hide()
		
	match state:
		"start":
			await play_sequence([
				"[Welcome, Player.]",
				"[Welcome to our monster contaminated school.]",
				"[Our world was infected by an unknown disease a while ago, and now…]",
				"(Distant screams and howls of pain tore your ears apart.)",
				"[They’re coming–they’re devouring us all!]",
				"[We desperately need your help, so please–]",
				"(The screams and prayers clouded your mind, until all you could feel was pain.)",
				"[Please, Player, we beg of you–save our world!]",
				"…",
				"[Will you help this world?]"
			])
			show_options(["Yes, bring me there immediately!", "Nah, I’m busy."])
			state = "choice_1"

		"first_refusal":
			await play_sequence([
				"[Busy with what? We’re dying here!]",
			])
			show_options(["[Well, a Player’s gotta do what a Player’s gotta do. Sorry not sorry!]",
				"[I suppose I can help.]",
				"[How badly?]"])
			state = "choice_2"
			
		"how_badly":
			await play_sequence([
				"[Really? Are you serious right now?!]",
				"[Blood are spewing everywhere, screams cannot be more horrying than this,
				and there are human limbs strewn across the floor!]"
			])
			show_options(["[Will you compensate me then?]",
				"[That's worse than I thought, I will help!]"])
			state = "choice_3"

		"compensation":
			await play_sequence([
				"[And if I say yes...?]"
			])
			show_options([
				"[I was just kidding! I’ll help with or without compensation!]",
				"[Aw heck, count me in, then!]",
				"[I’ll help–haha, just kidding, it’s still a no.]"
			])
			state = "choice_4"

		"final_refusal":
			await play_sequence([
				"[You will regret this.]",
				"(A menacing aura started to surround you.)",
				"[You may forget this world’s pleas…]",
				"[But Karma never forgets.]",
				"…",
				"[Now… Are you sure you still refuse to help?]"
			])
			show_options([
				"[I don’t help those who beg.]",
				"[*Gulp. …Yes.]"
			])
			state = "choice_5"

		"cruel":
			await play_sequence([
				"[You’re cruel, Player.]",
				"[And unfortunately… we do not need a cruel hero.]",
				"…",
				"{You’ve Died.}"
			])
			get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")

		"start_game":
			get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/main.tscn")

#----------------------------------------dialogue logic---------------------------------------------
func _on_button_pressed(index):
	match state:
		"choice_1":
			if index == 0:
				state = "start_game"
			else:
				state = "first_refusal"
			show_dialogue()

		"choice_2":
			if index == 0:
				state = "final_refusal"
			elif index == 1:
				state = "start_game"
			else:
				state = "how_badly"
			show_dialogue()
			
		"choice_3":
			if index == 0:
				state = "compensation"
			else:
				state = "start_game"
			show_dialogue()

		"choice_4":
			if index in [0, 1]:
				state = "start_game"
				if index == 1:
					moral_points -= 1
					state = "start_game"
			else:
				state = "final_refusal"
			show_dialogue()

		"choice_5":
			if index == 0:
				state = "cruel"
			else:
				moral_points -= 2
				state = "start_game"
			show_dialogue()

func show_options(option_texts):
	for i in range(buttons.size()):
		if i < option_texts.size():
			buttons[i].text = option_texts[i]
			buttons[i].show()
		else:
			buttons[i].hide()

#----------------------------------------play sequence----------------------------------------------
var glitch_keywords = [
	"screams",
	"player",
	"limbs strewn",
	"cruel",
	"karma",
	"unknown disease",
	"save our world",
	"dying"
]

func play_sequence(lines):
	for line in lines:
		if skip_all:
			return

		# Check if line contains any glitch-trigger keyword
		var triggered = false
		for keyword in glitch_keywords:
			if line.to_lower().contains(keyword):
				triggered = true
				break

		if triggered:
			await trigger_glitch()

		dialogue_label.text = line

		if skipping:
			continue

		await get_tree().create_timer(2).timeout

#----------------------------------on [what] button pressed-----------------------------------------
func _on_skip_button_pressed():
	skipping = true

func _on_skip_all_button_pressed():
	confirm_skip.popup_centered()

func _on_confirm_skip_confirmed():
	skip_all = true
	await play_sequence(["[Thank you, Player. We’ll bring you in now…]"])
	await get_tree().create_timer(2).timeout
	start_game()

#---------------------------so logic is logic-ing for confirm skip----------------------------------
func start_game():
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/main.tscn")

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
