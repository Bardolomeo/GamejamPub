extends Node2D

onready var textbox = $TextBox
onready var pause_menu = $PauseMenu
var paused = false

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		pause()

func pause():
	if paused == false:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused

func _ready():
	OS.window_fullscreen = true
	textbox.visible = true
	if GlobalVar.stage == 1:
		textbox.queue_content("An horrible figure stands before you, made of flesh and blood. It barely resembles a human.")
		textbox.queue_content("WATCH OUT!")
	if GlobalVar.stage == 2:
		textbox.queue_content("Several people melt together. Their minds, corrupted by the abyss.")
		textbox.queue_content("WATCH OUT!")
	if GlobalVar.stage == 3:
		textbox.queue_content("The air grows thicker, your sight is clouded, you're shivering with fear.")
		textbox.queue_content("...")

func _on_TextBox_textbox_done():
	GuiMusic.stop_music()
	get_tree().change_scene("res://export_combat/CombatContainer.tscn")
