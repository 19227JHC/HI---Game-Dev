extends Node2D


@export var destination_position: Vector2
@export var target_room_area: Area2D  # Assign this in the editor
@export var bottom_padding: int = 33  # optional camera padding


@onready var interaction_area: InteractionArea = $InteractionArea


func _ready():
	interaction_area.action_name = "[F] to enter door"
	interaction_area.interact = Callable(self, "_on_interact")
	

func _on_interact() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.start_room_transition(destination_position, self)
	else:
		print("Player not found!")

	$AnimatedSprite2D.play("open")
	
