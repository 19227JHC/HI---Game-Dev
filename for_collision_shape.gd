extends Node

func set_collision_disabled(item: Node, disabled: bool) -> void:
	if not item:
		return
	var shape: CollisionShape2D = item.get_node_or_null("StaticBody2D/CollisionShape2D")
	if shape:
		shape.disabled = disabled
