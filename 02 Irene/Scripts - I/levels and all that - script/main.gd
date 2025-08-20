extends Node2D

@export var level_number = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$CanvasLayer/Settings.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Pause
#func pause():
	#$CanvasLayer/Pause.visible = true
	#get_tree().paused = true

#func resume():
	#$CanvasLayer/Pause.visible = false
	#get_tree().paused = false

# Settings (overlay on top of pause) 	
#func open_settings():
	#var settings_scene = preload("res://02 Irene/Scenes - I/UI/settings.tscn").instantiate()
	#get_tree().current_scene.add_child(settings_scene) # add to level
	#settings_scene.show()
	#visible = false

#func close_settings():
	#$CanvasLayer/Settings.visible = false
	#CanvasLayer/Pause.visible = true
