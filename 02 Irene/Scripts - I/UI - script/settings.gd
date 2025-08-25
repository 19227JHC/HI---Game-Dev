extends Control


@onready var input_button_scene = preload("res://02 Irene/Scenes - I/levels and all that/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList


#var came_from_node: Node = null   # Will store PauseScreen or MainMenu reference

# FOR INPUT KEYS
var is_remapping = false
var action_to_remap = null
var remapping_button = null

# FOR CHANGING THE INTERACTION ACTION NAME IN ACCORDANCE TO WHAT WAS CHANGED
var changed_input_interact: String = ""
var changed_input_drink: String = ""

# (which one will show up)
var input_actions = {
	"up" : "Move Up",
	"left" : "Move Left",
	"down" : "Move Down",
	"right" : "Move Right",
	"attack" : "Attack",
	"esc" : "Pause",
	"interact" : "Interact",
	"drink" : "Drink"
}

# for clean returns from MainMenu/Pause
var opened_from: String = ""  # "pause" or "main_menu"


# Called when the node enters the scene tree for the first time.
func _ready():
	#visible = false
	$AnimationPlayer.play("RESET")
	_create_action_list()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#-------------------------------------KEY INPUTS CHANGE---------------------------------------------
func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
		
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().replace(" (Physical)", "")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	$press.play() # plays sound when button is pressed - HANNAH
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."


# HANNAH WAS HERE
func _on_input_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button


func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			# turn double click to single click
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
				
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()


func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().replace(" (Physical)", "")


#-------------------------------------------BUTTONS-------------------------------------------------
func _on_return_button_pressed():
	$press.play() # plays sound when button is pressed - HANNAH
	visible = false
	$AnimationPlayer.play("RESET")
	#queue_free()
	#if came_from_node:
		#came_from_node.show()


# HANNAH WAS HERE
func _on_return_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value/5)


func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)


# RESOLUTION
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


# reset THE KEY INPUTS
func _on_reset_button_pressed():
	$press.play() # plays sound when button is pressed - HANNAH
	_create_action_list()


# HANNAH WAS HERE
func _on_reset_button_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button
