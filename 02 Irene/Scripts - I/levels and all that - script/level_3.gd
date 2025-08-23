extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$endings_dialogue.set_active_dialogue("bad_ending")
	await $endings_dialogue._show_dialogue_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
