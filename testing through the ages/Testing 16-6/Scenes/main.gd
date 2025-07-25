extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)
