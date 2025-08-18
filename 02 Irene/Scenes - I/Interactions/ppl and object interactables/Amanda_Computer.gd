extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialogue_manager = $dialogue  # This should be your InteractableDialogue node


var dialogue_task = null


func _ready():
	interaction_area.action_name = "[F] to interact\nwith Amanda the Computer"
	interaction_area.interact = Callable(self, "_on_item_interacted")


# -------------------- ITEM INTERACTION --------------------
func _on_item_interacted():
	# $dialogue/CanvasLayer.show() # just in case?
	
	dialogue_manager.set_active_dialogue("computer_amanda")
	await dialogue_manager._show_dialogue_state()


# -------------------- RUN DIALOGUE --------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()
