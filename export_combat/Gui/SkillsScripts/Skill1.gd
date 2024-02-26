extends Button

var skill_name : String

func _ready():
	self.connect("pressed", self, "_on_press")
	
func _on_press() :
	var turn_order = get_tree().root.get_node("CombatContainer/Combat/Turn Order")
	if turn_order.active.stats.is_enemy == false:
		get_tree().root.get_node("CombatContainer/SkillWindow").hide()
		turn_order.active.do_skill.find_skill(skill_name, false)
		turn_order.active.skill_array[1].usage -= 1

func _on_SkillWindow_visibility_changed():
	var turn_order = get_tree().root.get_node("CombatContainer/Combat/Turn Order")
	if turn_order.active.skill_array[1].usage <= 0:
		self.disabled = true
		turn_order.active.skill_array[1].usage = 0
	skill_name = turn_order.active.skill_array[1].skill_name
	self.text = skill_name
	var skill = turn_order.active.skill_array[1]
	$"../Skill2Des".text = String(turn_order.active.skill_array[1].usage) + "/" + String(turn_order.active.skill_array[1].max_usage)
