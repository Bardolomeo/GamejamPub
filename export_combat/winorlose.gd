extends Node2D

class_name WinLose

onready var winscreen = $".."
onready var combat = $"../.."
onready var turn_order = $"../../Turn Order"

func check_combat_over():
	var arr = turn_order.char_arr
	match check_combat_end(arr) : 
		1:
			wol("You Lose!")
			$"/root/CombatContainer".get_node("HBoxContainer").visible = false
			$"/root/CombatContainer".get_node("Sprite").visible = false
			$"../../Turn Order".active.stats.is_enemy = false
			$"/root/CombatContainer/Combat".combat_end = 1
			return 1
		2: 
			wol("You Win!")
			$"/root/CombatContainer".get_node("HBoxContainer").visible = false
			$"/root/CombatContainer".get_node("Sprite").visible = false
			$"../../Turn Order".active.stats.is_enemy = false
			$"/root/CombatContainer/Combat".combat_end = 2
			return 1
	return 0

func check_combat_end(arr : Array):
	var players : Array
	var enemies : Array
	for n in arr:
		if is_instance_valid(n):
			if n.stats.is_enemy:
				enemies.append(n)
			else:
				players.append(n)
	if side_defeat(players) :
		return 1
	if side_defeat(enemies) :
		return 2
	return 0 
		
func side_defeat(arr : Array) :
	for n in arr :
		if n.stats.hp > 0:
			return 0
	return 1

func wol(string : String) :
	if string == "You Lose!":
		winscreen.winlose_label.text = string
		winscreen.gold_letter.visible = false
		winscreen.gold_value.visible = false
		winscreen.loot.visible = false
		combat.move_child(winscreen, combat.get_child_count())
	if string == "You Win!" :
		var gold = randi() % 11
		match gold:
			0: 
				gold = 10
				GlobalVar.gold += gold
			1: 
				gold = 5
				GlobalVar.gold += gold
			2: 
				gold = 3
				GlobalVar.gold += gold
			_:
				GlobalVar.gold += gold
	
		winscreen.gold_value.text = String(gold)
		combat.move_child(winscreen, combat.get_child_count())
	winscreen.animation_player.play("Appear")
	yield(get_tree().create_timer(4), "timeout")
	winscreen.animation_player.stop()
	$"../Button".show()
