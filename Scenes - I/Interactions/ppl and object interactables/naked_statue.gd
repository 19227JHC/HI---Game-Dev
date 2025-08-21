extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialogue_manager = $dialogue  # This should be your InteractableDialogue node


var dialogue_task = null
var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")

	interaction_area.action_name = "[F] to interact"
	interaction_area.interact = Callable(self, "_on_item_interacted")


# ------------------------------------ITEM INTERACTION----------------------------------------------
func _on_item_interacted():
	get_tree().paused = true
	
	$dialogue/CanvasLayer.show() # just in case?
	
	dialogue_manager.set_active_dialogue("naked_statue")
	await dialogue_manager._show_dialogue_state()


# -------------------------------------RUN DIALOGUE-------------------------------------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()
