extends HBoxContainer


signal turn_next

func _ready():
	self.connect("pressed", self, "_on_press")
	
func _on_press() :
	if $"../../../../Combat/Turn Order".active.stats.is_enemy == false:
		$"../../../../Combat/Turn Order".active.do_skill.find_skill("Attack", false)
		
func _on_enemy_selected():
	emit_signal("turn_next")
