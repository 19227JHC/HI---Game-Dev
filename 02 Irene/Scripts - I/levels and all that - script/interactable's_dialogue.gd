extends Control


signal option_selected(index: int)


@onready var dialogue_label: Label = $CanvasLayer/DialogueLabel
@onready var options_box: VBoxContainer = $CanvasLayer/OptionsBox
@onready var buttons: Array[Button] = [
	$CanvasLayer/OptionsBox/Button,
	$CanvasLayer/OptionsBox/Button2,
	$CanvasLayer/OptionsBox/Button3
]


@onready var skip_button = $CanvasLayer/VBoxContainer/SkipButton
@onready var skip_all_button = $CanvasLayer/VBoxContainer/SkipAllButton
@onready var confirm_skip = $CanvasLayer/ConfirmSkip


var skipping = false
var skip_all = false
var skip_confirmed = false


func _ready() -> void:
	$CanvasLayer.hide() # Hide until triggered
	for i in range(buttons.size()):
		buttons[i].connect("pressed", Callable(self, "_on_button_pressed").bind(i))


# --------------------------------the start of the dialogue-----------------------------------------
func start_dialogue(lines: Array, callback: Callable = Callable()) -> void:
	$CanvasLayer.show()
	get_tree().paused = true 	# how do i pause help
	options_box.hide()
	_play_sequence(lines, callback)


# ----------------------------------show lines in sequence------------------------------------------
func _play_sequence(lines: Array, callback: Callable) -> void:
	
	await get_tree().process_frame # Small delay so UI updates
	
	for line in lines:
		dialogue_label.text = str(line)
		await _wait_for_continue()
		
	$CanvasLayer.hide()
	# get_tree().paused = false
	
	if callback.is_valid():
		callback.call()


# -------------------Wait for player to press a key or click to continue----------------------------
func _wait_for_continue() -> void:
	var proceed := false
	while not proceed:
		await get_tree().process_frame
		if Input.is_action_just_pressed("ui_accept"):
			proceed = true


# -----------------------show the 'choice buttons' and wait for selection---------------------------
func show_options(options: Array) -> int:
	options_box.show()
	for i in range(buttons.size()):
		if i < options.size():
			buttons[i].text = str(options[i])
			buttons[i].show()
			buttons[i].disabled = false
		else:
			buttons[i].hide()

	var choice_index = await option_selected
	options_box.hide()
	return choice_index


# --------------------------------handles button clicks---------------------------------------------
func _on_button_pressed(index: int) -> void:
	emit_signal("option_selected", index)


# -------------------------BUTTONS (i mean for skipping purposes)-----------------------------------
func _on_end_dialogue_button_pressed():
	skipping = true


func _on_skip_button_pressed():
	confirm_skip.popup_centered()


func _on_confirm_skip_confirmed():
	skip_all = true
	skip_confirmed = true

	# Hide all buttons
	for button in buttons:
		button.hide()
	
	$CanvasLayer.hide()
