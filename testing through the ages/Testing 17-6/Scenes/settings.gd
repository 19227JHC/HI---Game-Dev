extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value/5)


func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)


func _on_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
			
	# Optional: Center window if not fullscreen
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_position(
			(DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2
		)
