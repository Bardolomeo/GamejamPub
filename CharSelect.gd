extends Control

onready var pause_menu = $PauseMenu
onready var anim = $AnimationPlayer
var paused = false
var next_scene = "res://Gui.tscn"
var chars_selected = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	anim.play("fade")

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		pause()
	if chars_selected == 2:
		$Embark.visible = true
	else:
		$Embark.visible = false



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
	MenuMusic.stop_music()
	GuiMusic.play_gui_music()
	get_tree().change_scene(next_scene)

func set_info_first(character : String):
	if character == "none":
		GlobalVar.firstmember = "none"
		GlobalVar.firstmemberlife = 0
		GlobalVar.firstmemberfirstmovePP = 0
		GlobalVar.firstmembersecondmovePP = 0
		GlobalVar.firstmemberthirdmovePP = 0
		$FirstSelect.visible = false
	else:
		GlobalVar.firstmember = character
		GlobalVar.firstmemberlife = CharactersData.ch_data[character]["vita"]
		GlobalVar.firstmemberfirstmovePP = SkillsData.skills_data[character]["Skill1"]["usage"]
		GlobalVar.firstmembersecondmovePP = SkillsData.skills_data[character]["Skill2"]["usage"]
		GlobalVar.firstmemberthirdmovePP = SkillsData.skills_data[character]["Skill3"]["usage"]
		$FirstSelect.play(character)
		$FirstSelect/bordername/MarginContainer/Name1.text = CharactersData.ch_data[character]["classe"]
		$FirstSelect.visible = true

func set_info_second(character : String):
	if character == "none":
		GlobalVar.secondmember = "none"
		GlobalVar.secondmemberlife = 0
		GlobalVar.secondmemberfirstmovePP = 0
		GlobalVar.secondmembersecondmovePP = 0
		GlobalVar.secondmemberthirdmovePP = 0
		$SecondSelect.visible = false
	else:
		GlobalVar.secondmember = character
		GlobalVar.secondmemberlife = CharactersData.ch_data[character]["vita"]
		GlobalVar.secondmemberfirstmovePP = SkillsData.skills_data[character]["Skill1"]["usage"]
		GlobalVar.secondmembersecondmovePP = SkillsData.skills_data[character]["Skill2"]["usage"]
		GlobalVar.secondmemberthirdmovePP = SkillsData.skills_data[character]["Skill3"]["usage"]
		$SecondSelect.play(character)
		$SecondSelect/bordername/MarginContainer/Name2.text = CharactersData.ch_data[character]["classe"]
		$SecondSelect.visible = true

func _on_Char1_pressed():
	if $GridContainer/Char1/char1Select.visible == false && chars_selected < 2:
		$GridContainer/Char1/char1Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch1")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch1")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch1")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char1/char1Select.visible == true:
		$GridContainer/Char1/char1Select.visible = false
		if GlobalVar.firstmember == "Ch1":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch1":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char_2_pressed():
	if $GridContainer/Char2/char2Select.visible == false && chars_selected < 2:
		$GridContainer/Char2/char2Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch2")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch2")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch2")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char2/char2Select.visible == true:
		$GridContainer/Char2/char2Select.visible = false
		if GlobalVar.firstmember == "Ch2":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch2":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char_3_pressed():
	if $GridContainer/Char3/char3Select.visible == false && chars_selected < 2:
		$GridContainer/Char3/char3Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch3")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch3")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch3")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char3/char3Select.visible == true:
		$GridContainer/Char3/char3Select.visible = false
		if GlobalVar.firstmember == "Ch3":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch3":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char_4_pressed():
	if $GridContainer/Char4/char4Select.visible == false && chars_selected < 2:
		$GridContainer/Char4/char4Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch4")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch4")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch4")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char4/char4Select.visible == true:
		$GridContainer/Char4/char4Select.visible = false
		if GlobalVar.firstmember == "Ch4":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch4":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char5_pressed():
	if $GridContainer/Char5/char5Select.visible == false && chars_selected < 2:
		$GridContainer/Char5/char5Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch5")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch5")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch5")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char5/char5Select.visible == true:
		$GridContainer/Char5/char5Select.visible = false
		if GlobalVar.firstmember == "Ch5":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch5":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char6_pressed():
	if $GridContainer/Char6/char6Select.visible == false && chars_selected < 2:
		$GridContainer/Char6/char6Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch6")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch6")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch6")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char6/char6Select.visible == true:
		$GridContainer/Char6/char6Select.visible = false
		if GlobalVar.firstmember == "Ch6":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch6":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char7_pressed():
	if $GridContainer/Char7/char7Select.visible == false && chars_selected < 2:
		$GridContainer/Char7/char7Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch7")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch7")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch7")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char7/char7Select.visible == true:
		$GridContainer/Char7/char7Select.visible = false
		if GlobalVar.firstmember == "Ch7":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch7":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char8_pressed():
	if $GridContainer/Char8/char8Select.visible == false && chars_selected < 2:
		$GridContainer/Char8/char8Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch8")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch8")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch8")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char8/char8Select.visible == true:
		$GridContainer/Char8/char8Select.visible = false
		if GlobalVar.firstmember == "Ch8":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch8":
			set_info_second("none")
		chars_selected = chars_selected - 1

func _on_Char9_pressed():
	if $GridContainer/Char9/char9Select.visible == false && chars_selected < 2:
		$GridContainer/Char9/char9Select.visible = true
		if chars_selected == 0:
			set_info_first("Ch9")
			chars_selected = chars_selected + 1
		elif chars_selected == 1:
			if GlobalVar.firstmember == "none":
				set_info_first("Ch9")
				chars_selected = chars_selected + 1
			else:
				set_info_second("Ch9")
				chars_selected = chars_selected + 1
	elif $GridContainer/Char9/char9Select.visible == true:
		$GridContainer/Char9/char9Select.visible = false
		if GlobalVar.firstmember == "Ch9":
			set_info_first("none")
		elif GlobalVar.secondmember == "Ch9":
			set_info_second("none")
		chars_selected = chars_selected - 1


func _on_Embark_pressed():
	proceed()
