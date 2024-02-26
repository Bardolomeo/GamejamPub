extends Button


func _ready():
	connect("pressed", $"/root/CombatContainer", "_on_Defend_pressed")
	connect("pressed", self, "_on_press")

func _on_press():
	var button_array : Array
	for n in enemies_array():
		if n.get_child(n.get_child_count() - 1).get_class() == "Button":
			button_array.append(n.get_child(n.get_child_count() - 1))
	$"/root/CombatContainer/Combat".lock_commands(1)
	if !$"/root/CombatContainer/Combat/Turn Order".active.stats.is_enemy:
		if(set_textbox()):
			return
		elif button_array:
			_destroy_buttons(button_array, enemies_array())
		else:
			$"/root/CombatContainer".set_effect("guard", null)
			$"/root/CombatContainer/Combat"._on_Button_turn_next()
			$"../../../../Combat/winscreen/winlose".check_combat_over()
	yield(get_tree().create_timer(1), "timeout")
	$"/root/CombatContainer/Combat".lock_commands(0)

func set_textbox():
	if ($"/root/CombatContainer".return_from_skills()):
		$"/root/CombatContainer".label.text = ("It's " + 
		$"/root/CombatContainer/Combat/Turn Order".active.stats.job
		+ "'s turn!\n\n\n\nWhat will you do?")
		return 1
	return 0
	
func enemies_array():
	var array : Array
	for n in $"/root/CombatContainer/Combat/Turn Order".char_arr :
		if n.stats.is_enemy && n.stats.hp > 0:
			array.append(n)
	return array
	
func _destroy_buttons(array : Array, enemies : Array):
	for n in enemies:
		if n != null:
			n.player.play("DEFAULT")
	for n in array:
		n.queue_free()
	

