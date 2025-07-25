extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	testEsc()


#-------------------------------------------------------------------------------
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
			DisplayServer.window_set_size(Vector2i(1280,1720))
			
	# Optional: Center window if not fullscreen
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_position(
			(DisplayServer.screen_get_size() - DisplayServer.window_get_size()) / 2
		)


# ------------------------------------------------------------------------------
# animation logic and stuff
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("space") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("space") and get_tree().paused:
		resume()


# BUTTONS
func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func _on_exit_to_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
