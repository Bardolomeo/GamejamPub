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
	
func _on_Button_turn_next():
	active = $"../Turn Order".active
	active.effects.turn_done = 1
	char_arr.sort_custom(turn_order, "speed_compar")
	yield(get_tree().create_timer(1), "timeout")
	delete_arrow()
	find_next_char()
	$"..".set_active_pointer(active)
	$"..".set_textbox()
	if active.stats.is_enemy:
		is_enemy_turn()

func delete_arrow():
	if active.get_node("Arrow") :
		active.get_node("Arrow").visible = false
		active.get_node("Arrow").queue_free()

func find_next_char():
#	if (aind < size):
	if aind < char_arr.size() - 1:
		aind += 1
	else:
		aind = 0
		
	if (char_arr[aind].stats.hp > 0 && 
	char_arr[aind].effects.turn_done == 0):
			$"../Turn Order".active = char_arr[aind]
			active = $"../Turn Order".active
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

func is_enemy_turn():
	yield(get_tree().create_timer(1), "timeout")
	match randi() % 5:
		4:
			active.get_node("DoSkill").find_skill("Special", 1)
		_:
			active.get_node("DoSkill").find_skill("Attack", 1)
