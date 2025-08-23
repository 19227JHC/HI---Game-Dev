extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D
@onready var dialogue_manager = $dialogue 


# for tables
@export var tables: Array[NodePath] = [
	NodePath("../table_and_chair"),
	NodePath("../table_and_chair2")
]


var dialogue_task = null
var player = null


func _ready():
	player = get_tree().get_first_node_in_group("player")

	var interact_key = get_key_for_action("interact")
	interaction_area.action_name = "[" + interact_key + "] to interact"
	interaction_area.interact = Callable(self, "_on_item_interacted")


# ----------to actively change the input keys in accordance to what it is in the InputMap-----------
func get_key_for_action(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	if events.size() > 0:
		var ev = events[0]
		if ev is InputEventKey:
			return OS.get_keycode_string(ev.physical_keycode)  # shows actual key, e.g. "F"
		elif ev is InputEventMouseButton:
			return "Mouse" + str(ev.button_index)
	return action_name  # fallback if no key found


# ------------------------------------ITEM INTERACTION----------------------------------------------
func _on_item_interacted():
	#get_tree().paused = true
	
	$dialogue/CanvasLayer.show() # just in case?
	
	# have to do place the keys first
	if not keys_placed():
		dialogue_manager.set_active_dialogue("not_yet_door_statue")
		await dialogue_manager._show_dialogue_state()
	else:
		#if you've done what you needed to do to leave
		dialogue_manager.set_active_dialogue("solved_puzzle_door_statue")
		await dialogue_manager._show_dialogue_state()
		# when finished, check the last state
		match dialogue_manager.last_state:
			"sacrificial_option":
				restart()


# --------------------------------------to restart--------------------------------------------------
func restart():
	# wait for player input
	await $dialogue._wait_for_continue()
	trigger_amanda_fade_out()
	
	# thank you note appears
	$dialogue/AnimationPlayer.play("blur")
	
	await get_tree().create_timer(2.5).timeout
	
	# hide everything
	$dialogue/CanvasLayer.hide()
	get_tree().paused = false
	
	get_tree().change_scene_to_file("res://02 Irene/Scenes - I/levels and all that/dialogue.tscn")


# just to see if the function work - update it doesn't
func trigger_amanda_fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0) # 1 second fade
	tween.tween_callback(func(): sprite.queue_free())
	$InteractionArea/CollisionShape2D.disabled = true

# -------------------------------------requirements to leave----------------------------------------
func keys_placed() -> bool:
	var count = 0
	for table_path in tables:
		var table = get_node_or_null(table_path)
		if table:
			var item = table.get_placed_item()
			if item and item.name in ["It_s_Chemical", "It_s_Chemical2"]:
				count += 1
	
	return count >= 2


# -------------------------------------RUN DIALOGUE-------------------------------------------------
func _run_item_dialogue():
	await dialogue_manager._show_dialogue_state()
