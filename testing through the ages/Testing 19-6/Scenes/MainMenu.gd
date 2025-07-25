extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_exit_button_pressed():
	get_tree().quit()
