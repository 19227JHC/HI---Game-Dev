extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")


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


# BUTTONS
func _on_settings_pressed():
	get_tree().paused = false
	SceneManager.go_to_scene("res://02 Irene/Scenes - I/UI/settings.tscn")

func _on_exit_to_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
