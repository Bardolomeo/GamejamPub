extends Node2D

var act_ind = 0
var characs : Array
var stage = 1
var enemy_turn = 0
var combat_end: int

onready var turn_order = $"Turn Order"
onready var winorlose = $winscreen

func _ready() :
	randomize()
	set_active_pointer($"Turn Order".active)
	if GlobalVar.stage == 1:
		$"/root/CombatContainer/background".stop()
		$"/root/CombatContainer/background".play("stage1")
	if GlobalVar.stage == 2:
		$"/root/CombatContainer/background".stop()
		$"/root/CombatContainer/background".play("stage2")
	if GlobalVar.stage == 3:
		$"/root/CombatContainer/background".stop()
		$"/root/CombatContainer/background".play("stage3")

func _process(_delta):
	if Input.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if 	$"Turn Order".active.stats.is_enemy:
		lock_commands(1)

func _emergency_unlock():
	if 	!$"Turn Order".active.stats.is_enemy && (
	get_tree().root.get_node(
	"CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Attack").disabled == true):
		lock_commands(0)

func set_active_pointer(active : Job) :
	var arrow = Sprite.new()
	arrow.texture = load("res://export_combat/Assets/CombatBG/freccia.png")
	arrow.name = "Arrow"
	active.add_child(arrow)
	arrow.set_rotation_degrees(90.0)
	arrow.position -= Vector2(0, 85)
	arrow.scale = Vector2(1.3, 1.3)

func set_textbox():
	if $"/root/CombatContainer/Combat/Turn Order".active.stats.is_enemy:
				$"/root/CombatContainer".label.text = ("Creatures turn... Take care")
	else :
		$"/root/CombatContainer".label.text = ("It's " + 
				 $"/root/CombatContainer/Combat/Turn Order".active.stats.job
				 + "'s turn!\n\n\n\nWhat will you do?")

func check_effects():
	var act_effects = $"Turn Order".active.effects
	
	if act_effects.guard != 0:
		act_effects.f_guard()
#	if act_effects.stun != 0:
#		if act_effects.check_stun():
#			return 1
#		return 0
	if act_effects.poison != 0:
		act_effects.check_poison()
	if act_effects.regen != 0:
		act_effects.check_regen()
	if act_effects.haste != 0:
		act_effects.check_haste()
	if act_effects.slow != 0:
		act_effects.check_slow()
	if act_effects.stren != 0:
		act_effects.check_stren()
	if act_effects.weak != 0:
		act_effects.check_weak()
	act_effects.color_manager()


func lock_commands(boolean):
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Attack").disabled = boolean
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Skills").disabled = boolean
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Defend").disabled = boolean


func _on_Button_pressed():
	var tree
	match combat_end:
		2:
			stats_update()
			if GlobalVar.choiceNum == GlobalVar.choiceCap:
				if GlobalVar.stage == 3:
					tree = get_tree().change_scene("res://export_combat/EndGame.tscn")
					return
				GlobalVar.stage += 1
				GlobalVar.choiceNum = 0
				GlobalVar.choiceCap = 10
				GlobalVar.oldtomeflag = 0
				if GlobalVar.stage != 3:
					tree = get_tree().change_scene("res://CharUnlock.tscn")
			else:
				GuiMusic.play_gui_music()
				GlobalVar.oldtomeflag = 0
				tree = get_tree().change_scene("res://Gui.tscn")
		_:
			reset_stats()
			tree = get_tree().change_scene("res://Menu.tscn")

func stats_update():
	for player in $"Turn Order".char_arr:
		if player.stats.party_member == GlobalVar.firstmember:
			if player.stats.hp > 0:
				GlobalVar.firstmemberlife = player.stats.hp
			else :
				GlobalVar.firstmemberlife = 1
			GlobalVar.firstmemberfirstmovePP = player.skill_array[1].usage 
			GlobalVar.firstmembersecondmovePP = player.skill_array[2].usage 
			GlobalVar.firstmemberthirdmovePP = player.skill_array[3].usage 
		if player.stats.party_member == GlobalVar.secondmember:
			if player.stats.hp > 0:
				GlobalVar.secondmemberlife = player.stats.hp
			else :
				GlobalVar.secondmemberlife = 1
			GlobalVar.secondmemberfirstmovePP = player.skill_array[1].usage 
			GlobalVar.secondmembersecondmovePP = player.skill_array[2].usage 
			GlobalVar.secondmemberthirdmovePP = player.skill_array[3].usage 
		if player.stats.party_member == GlobalVar.thirdmember:
			if player.stats.hp > 0:
				GlobalVar.thirdmemberlife = player.stats.hp
			else :
				GlobalVar.thirdmemberlife = 1
			GlobalVar.thirdmemberfirstmovePP = player.skill_array[1].usage 
			GlobalVar.thirdmembersecondmovePP = player.skill_array[2].usage 
			GlobalVar.thirdmemberthirdmovePP = player.skill_array[3].usage 

func reset_stats():
	GlobalVar.stage = 1
	GlobalVar.choiceNum = 0
	GlobalVar.choiceCap = 10
	GlobalVar.gold = 0
	GlobalVar.day = 0
	GlobalVar.secondmember = "none"
	GlobalVar.thirdmember = "none"
	GlobalVar.ancientRune = "none"
	GlobalVar.enchFeather = "none"
	GlobalVar.monocle = "none"
	GlobalVar.oldTome = "none"
	GlobalVar.oldtomeflag = 0
	GlobalVar.pocketDagger = "none"
	GlobalVar.regenStone = "none"
	InventoryData.item_data["Inv1"] = "none"
	InventoryData.item_data["Inv2"] = "none"
	InventoryData.item_data["Inv3"] = "none"
	InventoryData.item_data["Inv4"] = "none"
	InventoryData.item_data["Inv5"] = "none"
	InventoryData.item_data["Inv6"] = "none"
	GlobalVar.partypoison = false
	GlobalVar.partyweak = false
	GlobalVar.partyslow = false
	GlobalVar.partyregen = false
	GlobalVar.partyhaste = false
	GlobalVar.partystrength = false
	GlobalVar.enemystun = false
	GlobalVar.enemyweak = false

func set_party():
	if GlobalVar.firstmember != "none":
		characs.append(GlobalVar.firstmember)
	if GlobalVar.secondmember != "none":
		characs.append(GlobalVar.secondmember)
	if GlobalVar.thirdmember != "none":
		characs.append(GlobalVar.thirdmember)
