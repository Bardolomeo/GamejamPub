extends Node2D

var act_ind = 0
var characs : Array
var stage = 1
var enemy_turn = 0
onready var turn_order = $"Turn Order"
onready var winorlose = $winscreen

func _ready() :
	randomize()
	set_active_pointer($"Turn Order".active)
	$Timer.connect("timeout", self, "_emergency_unlock")

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

func _on_Button_turn_next():
	$"Turn Order".active.effects.turn_done = 1
	$Timer.start()
#	$"winscreen/winlose".check_combat_over()
	yield(get_tree().create_timer(0.1), "timeout")
	$"Turn Order".char_arr.sort_custom($"Turn Order", "speed_compar")
	if enemy_turn == number_of_enemies($"Turn Order".char_arr):
		enemy_turn = 0
		yield(get_tree().create_timer(1), "timeout")
		lock_commands(0)
	find_next_char()

func find_next_char():
	if $"Turn Order".active.get_node("Arrow") :
		$"Turn Order".active.get_node("Arrow").queue_free()
	var array = $"Turn Order".active.get_children()
	var last_node
	for n in array:
		last_node = n
	if last_node != $"Turn Order".active.get_node("Bar"):
		last_node.queue_free()
	if act_ind < $"Turn Order".char_arr.size() - 1 || act_ind < 0:
		act_ind += 1
	else :
		act_ind = 0
	var pred_active = $"Turn Order".active
	$"Turn Order".active = $"Turn Order".char_arr[act_ind]
	var arr = $"Turn Order".char_arr
	if $"Turn Order".active.stats.hp <= 0 || $"Turn Order".active.effects.turn_done:
		while act_ind < $"Turn Order".char_arr.size() - 1 && (
		$"Turn Order".active.stats.hp <= 0 ||
		$"Turn Order".active.effects.turn_done): 
			act_ind += 1
			$"Turn Order".active = $"Turn Order".char_arr[act_ind]
			var active = $"Turn Order".active
#			
		if act_ind + 1 == $"Turn Order".char_arr.size() && (
		$"Turn Order".char_arr[act_ind].stats.hp <= 0 ||
		$"Turn Order".active.effects.turn_done) :
			if $"Turn Order".active.effects.turn_done:
				reset_turn_order()
			for n in $"Turn Order".char_arr:
				if (n.stats.hp > 0 && !n.effects.turn_done) && n != $"Turn Order".active:
					$"Turn Order".active = n
					act_ind = $"Turn Order".char_arr.find($"Turn Order".active)
					break
	if pred_active == $"Turn Order".active:
		if act_ind + 1 < $"Turn Order".char_arr[act_ind + 1]:
			$"Turn Order".active = $"Turn Order".char_arr[act_ind + 1]
		else:
			for n in $"Turn Order".char_arr:
				if $"Turn Order".char_arr.find(n) == $"Turn Order".char_arr.size() - 1:
					reset_turn_order()
				if !n.stats.turn_done && n.stats.hp > 0:
					$"Turn Order".active = n
					act_ind = $"Turn Order".char_arr.find(n)
	var active = $"Turn Order".active
	if active.stats.is_enemy:
		lock_commands(active.stats.is_enemy)
	if ($"Turn Order".active.stats.is_enemy):
		enemy_turn += 1
	if !check_effects():
		if enemy_turn == 1:
			if enemy_turn != number_of_enemies($"Turn Order".char_arr):
				$"/root/CombatContainer".custom_timer(1, self, "post_wait_turn_next")
			else:
				$"/root/CombatContainer".custom_timer(1, self, "post_wait_turn_next")
		else:
			$"/root/CombatContainer".custom_timer(1, self, "post_wait_turn_next")

func post_wait_turn_next():
	set_textbox()
	var active = $"Turn Order".active
	set_active_pointer($"Turn Order".active)
	var SUCA =  $"Turn Order".active
	is_npc(SUCA)
	reset_turn_order()
	
func is_npc(active : Job):
	if active.starting_stats.is_enemy :
		if active.stats.hp > 0:
			match randi() % 5 :
				4:
					active.do_skill.find_skill("Special", true)
				_:
					active.do_skill.find_skill("Attack", true)
			$winscreen/winlose.check_combat_over()
			$"/root/CombatContainer".custom_timer(1.5, self, "_on_Button_turn_next")
		else:
			_on_Button_turn_next()

func number_of_enemies(char_arr):
	var number = 0
	for n in char_arr :
		if n.stats.is_enemy :
			if n.stats.hp > 0:
				number += 1
	return number

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
	if act_effects.stun != 0:
		if act_effects.check_stun():
			return 1
		return 0
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

func reset_turn_order():
	var turn_end = 1
	for n in $"Turn Order".char_arr:
		if !n.effects.turn_done && n.stats.hp > 0:
			turn_end = 0
	if turn_end:
		for n in $"Turn Order".char_arr:
			n.effects.turn_done = 0

func lock_commands(boolean):
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Attack").disabled = boolean
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Skills").disabled = boolean
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Defend").disabled = boolean


func _on_Button_pressed():
	match $winscreen/winlose.check_combat_over():
		1:
			get_tree().change_scene("res://Menu.tscn")
		2:
			get_tree().change_scene("res://Gui.tscn")
	
func set_party():
	if GlobalVar.firstmember != "none":
		characs.append(GlobalVar.firstmember)
	if GlobalVar.secondmember != "none":
		characs.append(GlobalVar.secondmember)
	if GlobalVar.thirdmember != "none":
		characs.append(GlobalVar.thirdmember)
