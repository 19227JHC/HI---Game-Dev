extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $Sprite2D


const file_name = "res://02 Irene/Scenes - I/levels and all that/level_"


func _ready():
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
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


func _process(delta):
	pass
