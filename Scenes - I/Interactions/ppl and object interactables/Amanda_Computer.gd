extends Node2D


signal healthChanged # 4 health bar


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $Sprite2D
@onready var dialogue_manager = $dialogue  # This should be your InteractableDialogue node


var dialogue_task = null
var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")

	interaction_area.action_name = "[F] to interact\nwith Amanda the Computer"
	interaction_area.interact = Callable(self, "_on_item_interacted")


# ------------------------------------ITEM INTERACTION----------------------------------------------
func _on_item_interacted():
	get_tree().paused = true
	
	$dialogue/CanvasLayer.show() # just in case?
	
	dialogue_manager.set_active_dialogue("computer_amanda")
	await dialogue_manager._show_dialogue_state()
	
	# when finished, check the last state
	match dialogue_manager.last_state:
		"great_ending":
			player.maxHealth /= 2
			gobal.maxHealth = player.maxHealth  # <-- update global
			# Also make sure currentHealth doesn't exceed the new max
			player.currentHealth = min(player.currentHealth, player.maxHealth)
			gobal.currentHealth = player.currentHealth
			healthChanged.emit()
			gobal.good_moral_points += 20
			print("Player current maxHealth:", player.maxHealth)
			print("Player current good_moral_points:", gobal.good_moral_points)
			# Disappear among the sea of butterflies, illusions of the past!
			trigger_amanda_fade_out()
			
		"cruel_ending":
			player.currentHealth /= 2
			gobal.currentHealth = player.currentHealth  # <-- update global
			healthChanged.emit()
			gobal.bad_moral_points += 10
			print("Player current currentHealth:", player.currentHealth)
			print("Player current bad_moral_points:", gobal.bad_moral_points)
			# Disappear among the sea of butterflies, illusions of the past!
			trigger_amanda_fade_out()
			
		"see_you_ending":
			pass # nothing happens


# -------------------------------------RUN DIALOGUE-------------------------------------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()


# ---------------------------------------fade out---------------------------------------------------
# bro i just figured out what tween means TOT
func trigger_amanda_fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0) # 1 second fade
	tween.tween_callback(func(): sprite.queue_free())
	$InteractionArea/CollisionShape2D.disabled = true
