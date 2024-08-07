extends Control

onready var container = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer
onready var start = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var end = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineEnd
onready var content = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var pause_menu = $PauseMenu
onready var choice1 = $HBoxContainer/InputWindow/VBoxContainer/Choice1
onready var choice2 = $HBoxContainer/InputWindow/VBoxContainer/Choice2
onready var chosen = $HBoxContainer/InputWindow/ChoiceMade
var paused = false
var choice_made = false
var which_choice = "X"
var fight_start = "res://export_combat/CombatContainer.tscn"
var next_scene = "res://Gui.tscn"

enum State {
	READY,
	READING,
	FINISHED
}

const READ_RATE = 0.05

# Called when the node enters the scene tree for the first time.

var current_state = State.READY
var content_queue = []
var n

func pause():
	if paused == false:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused

func _ready():
	randomize()
	n = randi() % 18
	while n == GlobalVar.prevChoice:
		n = randi() % 18
	GlobalVar.prevChoice = n
	print(n)
	print("Starting state: ready")
	hide_textbox()
	choice1.text = EventData.event_data[str(n)]["choices"]["A"]["desc"]
	choice2.text = EventData.event_data[str(n)]["choices"]["B"]["desc"]
	queue_content(EventData.event_data[str(n)]["scenario"])

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		pause()
	match current_state:
		State.READY:
			if !content_queue.empty():
				display_content()
			elif content_queue.empty():
				container.hide()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				content.percent_visible = 1.0
				$Tween.stop_all()
				# end.text = ">"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept") && choice_made == true:
				process_outcome(which_choice)

func queue_content(next_content):
	content_queue.push_back(next_content)

func hide_textbox():
	start.text = ""
	end.text = ""
	content.text = ""
	container.hide()

func show_text():
	container.show()
#	start.text = "#"

func display_content():
	var next_content = content_queue.pop_front()
	content.text = next_content
	content.percent_visible = 0.0
	change_state(State.READING)
	show_text()
	$Tween.interpolate_property(content, "percent_visible", 0.0, 1.0, len(next_content) * READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tween_tween_all_completed():
#	end.text = ">"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to ready")
		State.READING:
			print("Changing state to reading")
		State.FINISHED:
			print("Changing state to finished")

func _on_Choice1_pressed():
	choice_made = true
	which_choice = "A"
	choice1.visible = false
	choice2.visible = false
	chosen.visible = true
	change_state(State.READY)
	hide_textbox()
	queue_content(EventData.event_data[str(n)]["choices"]["A"]["result"])
	
func gain_hp(percentage : int):
	var maxhp : int = int(CharactersData.ch_data[GlobalVar.firstmember]["vita"])
	var healamount : int = maxhp * percentage / 100
	GlobalVar.firstmemberlife += healamount
	if GlobalVar.firstmemberlife > int(CharactersData.ch_data[GlobalVar.firstmember]["vita"]):
		GlobalVar.firstmemberlife = int(CharactersData.ch_data[GlobalVar.firstmember]["vita"])
	if GlobalVar.secondmember != "none":
		maxhp = int(CharactersData.ch_data[GlobalVar.secondmember]["vita"])
		healamount = maxhp * percentage / 100
		GlobalVar.secondmemberlife += healamount
		if GlobalVar.secondmemberlife > int(CharactersData.ch_data[GlobalVar.secondmember]["vita"]):
			GlobalVar.secondmemberlife = int(CharactersData.ch_data[GlobalVar.secondmember]["vita"])
	if GlobalVar.thirdmember != "none":
		maxhp = int(CharactersData.ch_data[GlobalVar.thirdmember]["vita"])
		healamount = maxhp * percentage / 100
		GlobalVar.thirdmemberlife += healamount
		if GlobalVar.thirdmemberlife > int(CharactersData.ch_data[GlobalVar.thirdmember]["vita"]):
			GlobalVar.thirdmemberlife = int(CharactersData.ch_data[GlobalVar.thirdmember]["vita"])

func lose_hp(percentage : int):
	var maxhp : int = int(CharactersData.ch_data[GlobalVar.firstmember]["vita"])
	var hurtamount : int = maxhp * percentage / 100
	GlobalVar.firstmemberlife -= hurtamount
	if GlobalVar.firstmemberlife <= 0:
		GlobalVar.firstmemberlife = 1
	if GlobalVar.secondmember != "none":
		maxhp = int(CharactersData.ch_data[GlobalVar.secondmember]["vita"])
		hurtamount = maxhp * percentage / 100
		GlobalVar.secondmemberlife -= hurtamount
		if GlobalVar.secondmemberlife <= 0:
			GlobalVar.secondmemberlife = 1
	if GlobalVar.thirdmember != "none":
		maxhp = int(CharactersData.ch_data[GlobalVar.thirdmember]["vita"])
		hurtamount = maxhp * percentage / 100
		GlobalVar.thirdmemberlife -= hurtamount
		if GlobalVar.thirdmemberlife <= 0:
			GlobalVar.thirdmemberlife = 1

func r_fullheal():
	var membersamount = 0
	if GlobalVar.thirdmember != "none":
		membersamount = 3
	elif GlobalVar.secondmember != "none" && GlobalVar.thirdmember == "none":
		membersamount = 2
	elif GlobalVar.secondmember == "none":
		membersamount = 1
	var n = randi() % membersamount + 1
	if n == 1:
		GlobalVar.firstmemberlife = int(CharactersData.ch_data[GlobalVar.firstmember]["vita"])
	if n == 2:
		GlobalVar.secondmemberlife = int(CharactersData.ch_data[GlobalVar.secondmember]["vita"])
	if n == 3:
		GlobalVar.thirdmemberlife = int(CharactersData.ch_data[GlobalVar.thirdmember]["vita"])

func gain_PP():
	GlobalVar.firstmemberfirstmovePP = int(SkillsData.skills_data[GlobalVar.firstmember]["Skill1"]["usage"])
	GlobalVar.firstmembersecondmovePP = int(SkillsData.skills_data[GlobalVar.firstmember]["Skill2"]["usage"])
	GlobalVar.firstmemberthirdmovePP = int(SkillsData.skills_data[GlobalVar.firstmember]["Skill3"]["usage"])
	if GlobalVar.secondmember != "none":
		GlobalVar.secondmemberfirstmovePP = int(SkillsData.skills_data[GlobalVar.secondmember]["Skill1"]["usage"])
		GlobalVar.secondmembersecondmovePP = int(SkillsData.skills_data[GlobalVar.secondmember]["Skill2"]["usage"])
		GlobalVar.secondmemberthirdmovePP = int(SkillsData.skills_data[GlobalVar.secondmember]["Skill3"]["usage"])
	if GlobalVar.thirdmember != "none":
		GlobalVar.thirdmemberfirstmovePP = int(SkillsData.skills_data[GlobalVar.thirdmember]["Skill1"]["usage"])
		GlobalVar.thirdmembersecondmovePP = int(SkillsData.skills_data[GlobalVar.thirdmember]["Skill2"]["usage"])
		GlobalVar.thirdmemberthirdmovePP = int(SkillsData.skills_data[GlobalVar.thirdmember]["Skill3"]["usage"])

func drain_PP():
	GlobalVar.firstmemberfirstmovePP -= 1
	if GlobalVar.firstmemberfirstmovePP < 0:
		GlobalVar.firstmemberfirstmovePP = 0
	GlobalVar.firstmembersecondmovePP -= 1
	if GlobalVar.firstmembersecondmovePP < 0:
		GlobalVar.firstmembersecondmovePP = 0
	GlobalVar.firstmemberthirdmovePP -= 1
	if GlobalVar.firstmemberthirdmovePP < 0:
		GlobalVar.firstmemberthirdmovePP = 0
	if GlobalVar.secondmember != "none":
		GlobalVar.secondmemberfirstmovePP -= 1
		if GlobalVar.secondmemberfirstmovePP < 0:
			GlobalVar.secondmemberfirstmovePP = 0
		GlobalVar.secondmembersecondmovePP -= 1
		if GlobalVar.secondmembersecondmovePP < 0:
			GlobalVar.secondmembersecondmovePP = 0
		GlobalVar.secondmemberthirdmovePP -= 1
		if GlobalVar.secondmemberthirdmovePP < 0:
			GlobalVar.secondmemberthirdmovePP = 0
	if GlobalVar.thirdmember != "none":
		GlobalVar.thirdmemberfirstmovePP -= 1
		if GlobalVar.thirdmemberfirstmovePP < 0:
			GlobalVar.thirdmemberfirstmovePP = 0
		GlobalVar.thirdmembersecondmovePP -= 1
		if GlobalVar.thirdmembersecondmovePP < 0:
			GlobalVar.thirdmembersecondmovePP = 0
		GlobalVar.thirdmemberthirdmovePP -= 1
		if GlobalVar.thirdmemberthirdmovePP < 0:
			GlobalVar.thirdmemberthirdmovePP = 0



func _on_Choice2_pressed():
	choice_made = true
	which_choice = "B"
	choice1.visible = false
	choice2.visible = false
	chosen.visible = true
	change_state(State.READY)
	hide_textbox()
	queue_content(EventData.event_data[str(n)]["choices"]["B"]["result"])

func process_outcome(which_choice : String):
	if GlobalVar.choiceNum == GlobalVar.choiceCap:
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "none":
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start":
		GuiMusic.stop_music()
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_party_weak":
		GlobalVar.partyweak = true
		GuiMusic.stop_music()
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_party_poison":
		GlobalVar.partypoison = true
		GuiMusic.stop_music()
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_party_slow":
		GlobalVar.partyslow = true
		GuiMusic.stop_music()
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_enemy_stun":
		GlobalVar.enemystun = true
		GuiMusic.stop_music()
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "gold_gain20":
		GlobalVar.gold = GlobalVar.gold + 20
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "small_heal":
		gain_hp(15)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "medium_heal":
		gain_hp(30)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "one_member_full_heal":
		r_fullheal()
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "small_hurt":
		lose_hp(15)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "medium_hurt":
		lose_hp(30)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "party_weak":
		GlobalVar.partyweak = true
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "party_poison":
		GlobalVar.partypoison = true
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "enemy_weak":
		GlobalVar.enemyweak = true
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "lose_gold":
		GlobalVar.gold -= 10
		if GlobalVar.gold <= 0:
			GlobalVar.gold = 0
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "regen_stone":
		InventoryData.item_data["Inv4"] = TrinketsData.item_data["Inv4"]
		GlobalVar.regenStone = "Inv4"
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "monocle":
		InventoryData.item_data["Inv1"] = TrinketsData.item_data["Inv1"]
		GlobalVar.monocle = "Inv1"
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "stage_2_longer_plus_medium_heal":
		GlobalVar.choiceCap += 2
		gain_hp(30)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "party_poison_plus_party_fullpp":
		GlobalVar.partypoison = true
		gain_PP()
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "drain_pp_plus_party_weak":
		drain_PP()
		GlobalVar.partyweak = true
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "old_tome_plus_fight_start":
		InventoryData.item_data["Inv6"] = TrinketsData.item_data["Inv6"]
		GlobalVar.oldTome = "Inv6"
		GuiMusic.stop_music()
		get_tree().change_scene(fight_start)
	else:
		get_tree().change_scene(next_scene)
