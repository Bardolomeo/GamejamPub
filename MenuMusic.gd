extends Node

var menumusic = load("res://Music/ost1.mp3")

func _ready():
	pass # Replace with function body.

func play_menu_music():
	$Music.stream = menumusic
	$Music.play()

func stop_music():
	$Music.stop()
