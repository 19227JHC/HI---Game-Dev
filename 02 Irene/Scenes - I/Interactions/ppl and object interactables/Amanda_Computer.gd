extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


@onready var dialogue_manager = $dialogue


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.action_name = "[F] to interact\nwith Amanda the Computer"
	interaction_area.interact = Callable(self, "_on_npc_interacted")
	

func _on_npc_interacted():
	await dialogue_manager.start_dialogue([
		"Hey there, stranger.",
		"line#2"
	])

	var choice = await dialogue_manager.show_options([
		"I might need some help, O Mighty Amanda.",
		"Just a lil' troublemaker traversing around. Got some tips?",
		"AH! Talking computer!"
	])

	if choice == 0:
		await dialogue_manager.start_dialogue(["line#3"])
	else:
		await dialogue_manager.start_dialogue(["line#4"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
