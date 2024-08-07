extends Node2D

onready var character = $Character
onready var label = $MarginContainer/Label
var chosencharacter = "none"

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVar.secondmember == "none":
		while GlobalVar.secondmember == "none":
			find_second(select_random())
	elif GlobalVar.secondmember != "none" && GlobalVar.thirdmember == "none":
		while GlobalVar.thirdmember == "none":
			find_third(select_random())
	else:
		character.hide()
		$Particles2D.visibile = false
		label.text = "Not much further now."
	character.play(chosencharacter)

func set_info_second(character : String):
	GlobalVar.secondmemberlife = CharactersData.ch_data[character]["vita"]
	GlobalVar.secondmemberfirstmovePP = SkillsData.skills_data[character]["Skill1"]["usage"]
	GlobalVar.secondmembersecondmovePP = SkillsData.skills_data[character]["Skill2"]["usage"]
	GlobalVar.secondmemberthirdmovePP = SkillsData.skills_data[character]["Skill3"]["usage"]

func set_info_third(character : String):
	GlobalVar.thirdmemberlife = CharactersData.ch_data[character]["vita"]
	GlobalVar.thirdmemberfirstmovePP = SkillsData.skills_data[character]["Skill1"]["usage"]
	GlobalVar.thirdmembersecondmovePP = SkillsData.skills_data[character]["Skill2"]["usage"]
	GlobalVar.thirdmemberthirdmovePP = SkillsData.skills_data[character]["Skill3"]["usage"]

func select_random():
	randomize()
	var n = randi() % 9
	if n == 0:
		return "Ch1"
	elif n == 1:
		return "Ch2"
	elif n == 2:
		return "Ch3"
	elif n == 3:
		return "Ch4"
	elif n == 4:
		return "Ch5"
	elif n == 5:
		return "Ch6"
	elif n == 6:
		return "Ch7"
	elif n == 7:
		return "Ch8"
	elif n == 8:
		return "Ch9"

func find_second(character : String):
		print("second " + character)
		if character != GlobalVar.firstmember && GlobalVar.secondmember == "none"  && GlobalVar.thirdmember == "none":
			chosencharacter = character
			print(character)
			GlobalVar.secondmember = character
			set_info_second(character)

func find_third(character : String):
		print("third " + character)
		if character != GlobalVar.firstmember && character != GlobalVar.secondmember && GlobalVar.thirdmember == "none":
			chosencharacter = character
			print(character)
			GlobalVar.thirdmember = character
			set_info_third(character)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		GuiMusic.play_gui_music()
		get_tree().change_scene("res://Gui.tscn")
