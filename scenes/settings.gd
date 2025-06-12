extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value/5)

# mute
func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)


func _on_back_to_start_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
