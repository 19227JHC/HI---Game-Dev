extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D


@export var item_name: String = "to disappear"


# Called when the node enters the scene tree for the first time.
func _ready():
	var interact_key = get_key_for_action("interact")
	interaction_area.action_name = "[" + interact_key + "] " + item_name
	interaction_area.interact = Callable(self, "disappear")


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


# -------------------------------------[F] to disappear---------------------------------------------
func disappear():
	the_fade_out()
	$StaticBody2D/CollisionShape2D.disabled = true


# ----------------------------------------the tween-------------------------------------------------
func the_fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0) # 1 second fade
	tween.tween_callback(func(): sprite.queue_free())
	$InteractionArea/CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
