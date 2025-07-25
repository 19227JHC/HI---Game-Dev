extends Node

@onready var dialogue_label = $DialogueLabel
@onready var options_box = $OptionsBox
var buttons = []

var state = "start"
var moral_points = 0

func _ready():
	buttons = $OptionsBox.get_children()
	for i in buttons.size():
		buttons[i].pressed.connect(func(): _on_button_pressed(i))
	show_dialogue()

func show_dialogue():
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
			get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

		"start_game":
			get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

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

func play_sequence(lines: Array) -> void:
	for line in lines:
		dialogue_label.text = line
		await get_tree().create_timer(2).timeout
