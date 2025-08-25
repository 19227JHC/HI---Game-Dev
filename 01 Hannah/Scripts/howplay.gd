extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_return_buttomn_pressed():
	$press.play() # plays sound when button is pressed
	visible = false
	$AnimationPlayer.play("RESET")

func _on_return_buttomn_mouse_entered():
	$hover.play() # plays sound when mouse enters/hovers over button
