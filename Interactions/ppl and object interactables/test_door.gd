extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


# for tables
@export var tables: Array[NodePath] = [
	NodePath("../table_and_chair"),
	NodePath("../table_and_chair2")
]
@export var enemy_group_name := "enemies"


const file_name = "res://02 Irene/Scenes - I/levels and all that/level_"


var item_name: String = "🧙‍♂️\nYOU SHALL NOT PASS."


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


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


# ----------------------------------------ON INTERACT-----------------------------------------------
func _on_interact():
	if all_enemies_killed() or keys_placed():
		door_open()
	else:
		print("You Shall Not Pass")


# ------------------------------------------CONDITIONS----------------------------------------------
func all_enemies_killed() -> bool:
	for enemy in get_tree().get_nodes_in_group(enemy_group_name):
		if enemy.is_inside_tree() and enemy.is_alive():  # You must define `is_alive()` in your enemy scripts
			return false
	return true


func keys_placed() -> bool:
	var count = 0
	for table_path in tables:
		var table = get_node_or_null(table_path)
		if table:
			var item = table.get_placed_item()
			if item and item.name in ["It_s_Chemical", "It_s_Chemical2"]:
				count += 1
	
	return count >= 2
	

# -------------------------------YOU SHALL PASS: door opens whooosh---------------------------------
func door_open():
	# Get the current scene path
	var current_scene_path: String = get_tree().current_scene.scene_file_path
	print("Current scene path:", current_scene_path)

	# Extract the filename from the path
	var filename: String = current_scene_path.get_file()
	print("Filename:", filename)

	# Use a regex to extract the level number from the filename
	var regex := RegEx.new()
	regex.compile("level_(\\d+)\\.tscn")

	var result := regex.search(filename)
	if result:
		var level_number := result.get_string(1).to_int()
		var next_level_number := level_number + 1
		print(next_level_number)

		# Make next level file name
		var next_level_filename := "level_%d.tscn" % next_level_number

		# Get the (res://scenes/) thing of the current scene
		var scene_dir: String = current_scene_path.get_base_dir()

		# Combine the (res://scenes/) thing and filename to get full path
		var next_level_path := scene_dir.path_join(next_level_filename)
		print(next_level_path)

		# Load next level
		get_tree().change_scene_to_file(next_level_path)

	else:
		printerr("Could not find level number in filename.")


func _process(_delta):
	if all_enemies_killed() or keys_placed():
		var interact_key = get_key_for_action("interact")
		interaction_area.action_name = "[" + interact_key + "] to enter"
	else:
		interaction_area.action_name = item_name
