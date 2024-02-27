extends Button

signal turn_next

func _ready():
	connect("pressed", $"/root/CombatContainer", "_on_Attack_pressed")
	connect("pressed", self, "_on_press")
	
func _on_press() :
		if ($"/root/CombatContainer".return_from_skills()):
			$"/root/CombatContainer".label.text = ("It's " + 
			$"/root/CombatContainer/Combat/Turn Order".active.stats.job
			+ "'s turn!\n\n\n\nWhat will you do?")
			return
		elif $"/root/CombatContainer/Combat/Turn Order".active.stats.is_enemy == false:
			 $"../../../../Combat/Turn Order".active.do_skill.find_skill("Attack", false)
			 $"../../../../Combat/winscreen/winlose".check_combat_over()
		
#func _on_enemy_selected():
#	connect("turn_next", $"../../../../Combat/TurnNext", "_on_Button_turn_next")
#	emit_signal("turn_next")
	
