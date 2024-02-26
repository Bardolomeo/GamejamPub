extends Control

onready var tree = $"../"

func _on_Resume_pressed():
	tree.pause()


func _on_Quit_pressed():
	get_tree().quit()
