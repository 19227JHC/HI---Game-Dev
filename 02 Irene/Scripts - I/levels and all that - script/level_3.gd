extends Control


@export var level_number = 3
# explanation why it's level 3 and good_ending isn't:
# it's because in the test_door script, I made it so that the path of the scene it loads next is the
# "level_(\\d+)\\.tscn"; change that to int and add 1 to it, aka path to level 3-
# and ba-dam! level_number 3 and level_3 naming here.
# why the good_ending doesn't have this even though it technically is also 'level 3', you ask?
# simple, because it doesn't require a door! it uses the door_statue instead!


@onready var dialogue_manager = $endings_dialogue


func _ready():
	$endings_dialogue.set_active_dialogue("bad_ending")
	await $endings_dialogue._show_dialogue_state()
	
	match dialogue_manager.last_state:
		"secret_ending_bad_ending":
			get_tree().quit()
		"end_this":
			get_tree().quit()
		"restart":
			get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")
