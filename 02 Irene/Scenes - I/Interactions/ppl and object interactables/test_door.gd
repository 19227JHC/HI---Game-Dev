extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


# Assign these in the editor or using onready vars
@export var tables: Array[NodePath] = [
	NodePath("../table_and_chair"),
	NodePath("../table_and_chair")
]
@export var enemy_group_name := "enemies"

const file_name = "res://02 Irene/Scenes - I/levels and all that/level_"

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	if all_enemies_killed() or required_items_placed():
		door_open()
	else:
		print("You Shall Not Pass")


func all_enemies_killed() -> bool:
	for enemy in get_tree().get_nodes_in_group(enemy_group_name):
		if enemy.is_inside_tree() and enemy.is_alive():  # You must define `is_alive()` in your enemy scripts
			return false
	return true


func required_items_placed() -> bool:
	var count = 0
	for table_path in tables:
		var table = get_node_or_null(table_path)
		if table:
			var item = table.get_placed_item()
			print("Item on table", table.name, ":", item)
			if item and item.name in ["It'sChemical", "It'sChemical2"]:
				count += 1
				print("Count:", count)
			else:
				print("Item not matching or missing on table", table.name)
		else:
			print("Table not found at path:", table_path)
	
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

		# Construct next level file name
		var next_level_filename := "level_%d.tscn" % next_level_number

		# Get the directory of the current scene (e.g., res://scenes/)
		var scene_dir: String = current_scene_path.get_base_dir()

		# Combine directory and filename to get full path
		var next_level_path := scene_dir.path_join(next_level_filename)
		print(next_level_path)

		# Load the next level
		get_tree().change_scene_to_file(next_level_path)

	else:
		printerr("Could not find level number in filename.")


func _process(_delta):
	# Debug check: remove this later
	if Input.is_action_just_pressed("ui_debug"):
		print("Enemies dead:", all_enemies_killed())
		print("Chemicals placed:", required_items_placed())
		
	if all_enemies_killed() or required_items_placed():
		interaction_area.action_name = "[F] to enter"
	else:
		interaction_area.action_name = "🧙‍♂️\nYOU SHALL NOT PASS."
