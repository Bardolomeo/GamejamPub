extends Node

var guimusic = load("res://Music/level1.mp3")

func _ready():
	pass # Replace with function body.

func play_gui_music():
	$Music.stream = guimusic
	if $Music.is_playing() == false:
		$Music.play()

func stop_music():
	$Music.stop()
