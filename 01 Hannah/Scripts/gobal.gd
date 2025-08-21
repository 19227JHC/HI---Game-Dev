extends Node

var player_current_attack = false

# won't be seen; it's just a bonus feature in the bg :)
var good_moral_points: int = 0
var bad_moral_points: int = 0

var currentHealth: int = 120
var maxHealth: int = 120

# --------------------------------------RESETS EVERYTHING-------------------------------------------
func reset():
	maxHealth = 120
	currentHealth = maxHealth
	good_moral_points = 0
	bad_moral_points = 0
	player_current_attack = false
