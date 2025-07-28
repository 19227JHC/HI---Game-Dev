extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/dialogue.tscn")


func _on_settings_button_pressed():
	get_tree().paused = false
	SceneManager.go_to_scene("res://02 Irene/Scenes - I/UI/settings.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
	
func testEsc():
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")
