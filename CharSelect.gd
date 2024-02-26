extends Control

onready var pause_menu = $PauseMenu
onready var anim = $AnimationPlayer
var paused = false
var next_scene = "res://Gui.tscn"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	anim.play("fade")

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

func proceed():
	anim.play_backwards("fade")
	get_tree().paused = true
	yield(get_tree().create_timer(2.5), "timeout")
	get_tree().paused = false
	get_tree().change_scene(next_scene)

func set_info(character : String):
	var firstmemberlife = CharactersData.ch_data[character]["vita"]
	var firstmemberfirstmovePP = SkillsData.skills_data[character]["Skill1"]["usage"]
	var firstmembersecondmovePP = SkillsData.skills_data[character]["Skill2"]["usage"]
	var firstmemberthirdmovePP = SkillsData.skills_data[character]["Skill3"]["usage"]


func _on_Char1_pressed():
	GlobalVar.firstmember = "Ch1"
	set_info("Ch1")
	proceed()

func _on_Char_2_pressed():
	GlobalVar.firstmember = "Ch2"
	set_info("Ch2")
	proceed()

func _on_Char_3_pressed():
	GlobalVar.firstmember = "Ch3"
	set_info("Ch3")
	proceed()

func _on_Char_4_pressed():
	GlobalVar.firstmember = "Ch4"
	set_info("Ch4")
	proceed()

func _on_Char5_pressed():
	GlobalVar.firstmember = "Ch5"
	set_info("Ch5")
	proceed()

func _on_Char6_pressed():
	GlobalVar.firstmember = "Ch6"
	set_info("Ch6")
	proceed()

func _on_Char7_pressed():
	GlobalVar.firstmember = "Ch7"
	set_info("Ch7")
	proceed()

func _on_Char8_pressed():
	GlobalVar.firstmember = "Ch8"
	set_info("Ch8")
	proceed()

func _on_Char9_pressed():
	GlobalVar.firstmember = "Ch9"
	set_info("Ch9")
	proceed()
