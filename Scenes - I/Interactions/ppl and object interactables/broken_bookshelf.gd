extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: Sprite2D = $StaticBody2D/Sprite2D


@export var item_name: String = "[F] to disappear"


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.action_name = item_name
	interaction_area.interact = Callable(self, "disappear")


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
