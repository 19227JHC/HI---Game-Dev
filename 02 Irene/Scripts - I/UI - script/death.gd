extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	return


# the animation starts hereee
func show_death_screen():
	visible = true
	$AnimationPlayer.play("blur")


#--------------------------------------------buttons------------------------------------------------
#func _on_restart_pressed():
	#visible = false
	#$AnimationPlayer.play("RESET")
	#get_tree().reload_current_scene()


# restart will essentially become the same as this, so. imma just delete that
func _on_exit_to_menu_pressed():
	# resets stats
	gobal.reset()
	visible = false
	$AnimationPlayer.play("RESET")
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/UI/MainMenu.tscn")
