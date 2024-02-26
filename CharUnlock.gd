extends Node2D

onready var character = $Character
onready var characteranim = $Character/CharAnim
var options = [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var n = options[randi() % options.size()]
	print(n)
	if n == 1:
		character.play("armless")
	elif n == 2:
		character.play("blade")
	elif n == 3:
		character.play("claw")
	elif n == 4:
		character.play("frost")
	elif n == 5:
		character.play("holed")
	elif n == 6:
		character.play("mistique")
	elif n == 7:
		character.play("morphed")
	elif n == 8:
		character.play("spore")
	elif n == 9:
		character.play("stinger")

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Gui.tscn")
