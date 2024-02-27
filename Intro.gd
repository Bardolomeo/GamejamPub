extends Node2D

onready var textbox = $TextBox
onready var intro_1 = $Intro1
onready var intro_2 = $Intro2
onready var anim = $AnimationPlayer
onready var black = $Black
onready var music = $AudioStreamPlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var intro_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	anim.play("fade")
	yield(get_tree().create_timer(2), "timeout")
	music.play()
	textbox.visible = true
	textbox.queue_content("I've told you the tales about the city of Equinox. A place built by the brightest minds of our age, containing wonders that can scarcely be imagined. They say it just disappeared one moonless night, devoured by a thick fog the same color as amethyst, never to be seen again.")
	textbox.queue_content("Some say that a witch casted a hex on it and its inhabitants, others say that some profane cultists brought an untold deity into this world...\n\nThe only certainty is that evil now reigns in that place.")
	textbox.queue_content("Do you remember that amulet that I gave to you that day?\n\nIt has the power to lead you into that decrepit city and protect you from the horrors that lie within.")
	textbox.queue_content("I wish that I could help you more Matthiew, but this is a quest that only you can complete. With that amulet you can use your own fears to fight against every enemy you could encounter and free that place from the evil that hosts it.")
	textbox.queue_content("You have to use your new power to free the city from whatever monstrosities you'll find inside.\nReach the core of that corruption and unleash the power of the amulet.\nIt's the only way.")
	textbox.queue_content("Now go, my niece, your journey starts now...At the gates of Equinox.")

func _process(_delta):
	if Input.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("ui_cancel"):
		textbox.hide()
		anim.play_backwards("fade")
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://Menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextBox_textbox_done():
	anim.play_backwards("fade")
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Menu.tscn")

func _on_TextBox_change_bg():
	get_tree().paused = true
	textbox.visible = false
	anim.play_backwards("fade")
	yield(get_tree().create_timer(1), "timeout")
	if intro_num == 0:
		intro_num = 1
		intro_1.visible = true
	else:
		intro_2.visible = true
	anim.play("fade")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().paused = false
	textbox.visible = true
