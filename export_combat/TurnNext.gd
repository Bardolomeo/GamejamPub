extends Node

var active : Job
onready var char_arr = $"../Turn Order".char_arr
onready var turn_order = $"../Turn Order"

var eturn : int = 0
var pturn : int = 0
var aind : int = 0

func _ready():
	randomize()
	aind = 0
	yield(get_tree().create_timer(1), "timeout")
	if $"../Turn Order".active.stats.is_enemy:
		active = $"../Turn Order".active
		is_enemy_turn()
	
func _on_Button_turn_next():
	set_turn_start_vars()
	for n in char_arr:
		if n.stats.hp > 0:
			n.effects.color_manager()
	yield(get_tree().create_timer(1), "timeout")
	delete_arrow()
	if !(handle_haste_missplacement()):
		find_next_char()
	$"..".set_active_pointer(active)
	$"../winscreen/winlose".check_combat_over()
	$"..".set_textbox()
	if active.stats.is_enemy:
		is_enemy_turn()
	if active.stats.is_enemy == false:
		if active.effects.stun == 0:
			$"..".lock_commands(0)
		else:
			$"..".lock_commands(1)
			yield(get_tree().create_timer(0.5), "timeout")
			check_stun()

func set_turn_start_vars():
	active = $"../Turn Order".active
	active.effects.turn_done = 1
	char_arr = $"../Turn Order".char_arr
	char_arr.sort_custom(turn_order, "speed_compar")

func handle_haste_missplacement():
	var ret = 0
	
	for n in char_arr:
		if (!n.effects.turn_done && n.stats.hp > 0
		&& char_arr.find(n) < char_arr.find(active)):
			$"../Turn Order".active = n
			active = $"../Turn Order".active
			ret = 1
	return ret

func delete_arrow():
	if active.get_node("Arrow") :
		active.get_node("Arrow").visible = false
		active.get_node("Arrow").queue_free()

func find_next_char():
	if aind < char_arr.size() - 1:
		aind += 1
	else:
		aind = 0
		
	if (char_arr[aind].stats.hp > 0 && 
	char_arr[aind].effects.turn_done == 0):
			$"../Turn Order".active = char_arr[aind]
			active = $"../Turn Order".active
			$"..".check_effects()
	else:
		check_round_end()
		find_next_char()

func check_round_end():
	var round_end = 0

	for cha in char_arr :
		if cha.effects.turn_done == 0 && cha.stats.hp > 0:
			round_end = 1
	if round_end == 0:
		for cha in char_arr:
			cha.effects.turn_done = 0
			aind = -1
			while char_arr[aind + 1].stats.hp < 0: 
				aind += 1

func is_enemy_turn():
	yield(get_tree().create_timer(1), "timeout")
	if active.effects.stun == 1:
		check_stun()
		return
	match randi() % 4:
		3:
			active.get_node("DoSkill").find_skill("Special", 1)
		_:
			active.get_node("DoSkill").find_skill("Attack", 1)

func check_stun():
	active.effects.stun = 0
	active.sprite2d.play("default")
	active.sprite2d.self_modulate = Color(1,1,1)
	_on_Button_turn_next()
	return 1
