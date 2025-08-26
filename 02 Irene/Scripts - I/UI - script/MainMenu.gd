extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	# $VBoxContainer/start_button.grab_focus() cuz it doesn't look good
	$CanvasLayer/Settings.visible = false
	$CanvasLayer/Howplay.visible = false
	gobal.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# -----------------------------FOR SETTINGS (to access it CLEANLY)----------------------------------
#func open_settings():
	#var settings_scene = preload("res://02 Irene/Scenes - I/UI/settings.tscn").instantiate()
	#settings_scene.came_from_node = self   # track origin
	#get_tree().current_scene.add_child(settings_scene)
	#settings_scene.show()
	#$CanvasLayer/Settings.show()
	# visible = false


# ----------------------------------------BUTTONS---------------------------------------------------
func _on_start_button_pressed():
	$press.play() # plays sound when button is pressed - HANNAH
	get_tree().paused = false
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/dialogue.tscn")

# HANNAH WAS HERE
func _on_start_button_mouse_entered():
	$hover.play()  # plays sound when mouse enters/hovers over button
	
func _on_settings_button_pressed():
	$press.play() # plays sound when button is pressed - HANNAH
	#open_settings()
	$CanvasLayer/Settings.visible = true
	$CanvasLayer/Settings/AnimationPlayer.play("fade")

# HANNAH WAS HERE
func _on_settings_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button

func _on_exit_button_pressed():
	$press.play() # plays sound when button is pressed - HANNAH
	get_tree().quit()


# HANNAH WAS HERE
func _on_exit_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button

func _on_tutorial_button_pressed():
	$CanvasLayer/Howplay/AnimationPlayer.play("fade")
	$CanvasLayer/Howplay.visible = true

func _on_tutorial_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button
