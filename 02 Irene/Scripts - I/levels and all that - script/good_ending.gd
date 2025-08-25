extends Control


@onready var dialogue_manager = $endings_dialogue


func _ready():
	# disable glitches because it's the 'good' one!
	$endings_dialogue/CanvasLayer2/GlitchLabel.hide()
	$endings_dialogue/CanvasLayer2/GlitchToggle.hide()
	$endings_dialogue/CanvasLayer/Glitch.hide()
	
	$endings_dialogue.set_active_dialogue("good_ending")
	await $endings_dialogue._show_dialogue_state()
	match dialogue_manager.last_state:
		"true_end":
			get_tree().quit()
		"restart_end":
			get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")
