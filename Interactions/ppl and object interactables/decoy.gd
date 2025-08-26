extends Node2D


@onready var interaction_area: InteractionArea = $InteractionArea


var item_name: String = "YOU SHALL NEVER PASS,\n\nEVIL PLAYER."


# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.action_name = item_name

# DOES ABSOLUTELY NOTHING AS IT'S JUST A DECOY LMAAOOOOO
# oh you know what'd be funny? erase the wizard as the clue that it ain't the real one B)

# HA, SIKE! GET TRICKED - PLAY RICK ASTLEY  NEVER GONNA GIVE YOU UP
