extends Node2D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label


const base_text = "" # so that it won't be [F] You Shall Not Pass


var active_areas = []
var can_interact = true


func register_area(area: InteractionArea):
	active_areas.push_back(area)	

func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)


func interact():
	print("Interact signal triggered for:", self.name)


func _process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return

	# Clean up invalid areas before sorting
	active_areas = active_areas.filter(func(area):
		var valid = area != null and area.is_inside_tree()
		return valid
	)
	
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position
		label.global_position.y -= 45
		label.global_position.x -= label.size.x/2
		label.show()
	else:
		label.hide()


func _sort_by_distance_to_player(area1, area2):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return false

	if area1 == null:
		return false
	if area2 == null:
		return true  # if area1 is valid but area2 isn't, area1 wins

	if not area1.is_inside_tree():
		return false
	if not area2.is_inside_tree():
		return true

	var dist1 = player.global_position.distance_to(area1.global_position)
	var dist2 = player.global_position.distance_to(area2.global_position)

	return dist1 < dist2


func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0 :
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
