extends Control

onready var skills = $SkillWindow
onready var skilldesc = $SkillWindow/DescWindow
onready var txtpanel = $HBoxContainer/TextWindow/Panel
#onready var desc = $SkillWindow/DescWindow
onready var line_start = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var label = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var line_end = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineEnd
onready var pause_menu = $PauseMenu
var paused = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	line_start.text = ""
	label.text = "It's PartyMember's turn!\n\n\n\nWhat will you do?"
	line_end.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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

func _on_Skills_pressed():
	hide_txt()
	skills.visible = true

func _on_Attack_pressed():
	label.text = "Who will you attack?"
	skills.visible = false
	skilldesc.visible = false
	show_txt()
#	desc.visible = false

func _on_Defend_pressed():
	label.text = "You prepare to defend yourself!"
	skills.visible = false
	skilldesc.visible = false
	show_txt()
#	desc.visible = false

func hide_txt():
	line_start.visible = false
	label.visible = false
	line_end.visible = false
	txtpanel.visible = false

func show_txt():
	line_start.visible = true
	label.visible = true
	line_end.visible = true
	txtpanel.visible = true
