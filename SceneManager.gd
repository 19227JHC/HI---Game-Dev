extends Node

var previous_scene_path: String = ""

func go_to_scene(scene_path: String):
	if get_tree().current_scene:
		previous_scene_path = get_tree().current_scene.scene_file_path
		print("Storing previous scene:", previous_scene_path)
	get_tree().change_scene_to_file(scene_path)

func return_to_previous_scene():
	print("Returning to:", previous_scene_path)
	if previous_scene_path != "":
		get_tree().change_scene_to_file(previous_scene_path)
	else:
		print("No previous scene to return to.")
