extends Button

func _ready():
	connect("pressed", get_tree().root.get_node("CombatContainer"), "_on_Skills_pressed")
	connect("pressed", self, "_on_press")
	
func _on_press():
#	$"../../../../Combat/winscreen/winlose".check_combat_over()
	pass
#		return
