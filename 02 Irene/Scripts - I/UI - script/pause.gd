extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")
	visible = false
	$CanvasLayer/Settings.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	testEsc()


# animation logic and stuff
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	visible = true

func resume():
	$AnimationPlayer.play_backwards("blur")
	visible = false
	get_tree().paused = false

func testEsc():
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()
	

# -----------------------------FOR SETTINGS (to access it CLEANLY)----------------------------------
#func open_settings():
	#var settings_scene = preload("res://02 Irene/Scenes - I/UI/settings.tscn").instantiate()
	#settings_scene.came_from_node = self   # track origin
	#get_tree().current_scene.add_child(settings_scene)
	#settings_scene.show()
	#$CanvasLayer/Settings.show()
	#visible = false


# BUTTONS
func _on_settings_pressed():
	#open_settings()
	$CanvasLayer/Settings.visible = true
	$CanvasLayer/Settings/AnimationPlayer.play("fade")

func _on_exit_to_menu_pressed():
	$press.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")

func _on_resume_pressed():
	$press.play()
	resume()

func _on_restart_pressed():
	$press.play()
	resume()
	get_tree().reload_current_scene()




func _on_resume_mouse_entered():
	$hover.play()

func _on_restart_mouse_entered():
	$hover.play()

func _on_settings_mouse_entered():
	$hover.play()

func _on_exit_to_menu_mouse_entered():
	$hover.play()
