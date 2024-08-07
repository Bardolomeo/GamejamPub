extends Control
onready var descwindow = $DescWindow
onready var line_start = $DescWindow/HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var label = $DescWindow/HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var line_end = $DescWindow/HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready	var turn_order = get_tree().root.get_node("/root/CombatContainer/Combat/Turn Order")


func _ready():
	line_start.text = ""
	label.text = ""
	line_end.text = ""

func _on_Skill1_pressed():
	execute_skill(1)
	$"../Combat".lock_commands(1)

func _on_Skill2_pressed():
	execute_skill(2)
	$"../Combat".lock_commands(1)

func _on_Skill3_pressed():
	execute_skill(3)
	$"../Combat".lock_commands(1)

func set_skills():
	for n in 3:
		set_skill_namedesc(n + 1)

func set_skill_namedesc(index):
	var skill_button = get_node("HBoxContainer/MarginContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer" 
								+ String(index) 
								+ "/Skill" 
								+ String(index))
	var skill_desc = get_node("HBoxContainer/MarginContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer" 
								+ String(index)
								+ "/Skill"
								+ String(index) + "Des")

	if turn_order.active.skill_array[index].usage <= 0:
		skill_button.disabled = true
		turn_order.active.skill_array[index].usage = 0
	else:
		skill_button.disabled = false
	skill_button.text = turn_order.active.skill_array[index].skill_name
	skill_desc.text = ( "Skill Points:    " +
						String(turn_order.active.skill_array[index].usage) + 
						"/" + 
						String(turn_order.active.skill_array[index].max_usage))

func execute_skill(index):
	turn_order.active.do_skill.find_skill(turn_order.active.skill_array[index].skill_name, false)
	turn_order.active.skill_array[index].usage -= 1
#	get_tree().root.get_node("/root/CombatContainer/Combat/winscreen/winlose").check_combat_over()
	if self.visible :
		$"..".show_txt()
		self.visible = false


func _on_Skill1_mouse_entered():
	line_start.text = ""
	label.text = turn_order.active.skill_array[1].description
	line_end.text = ""
	descwindow.visible = true

func _on_Skill2_mouse_entered():
	line_start.text = ""
	label.text = turn_order.active.skill_array[2].description
	line_end.text = ""
	descwindow.visible = true

func _on_Skill3_mouse_entered():
	line_start.text = ""
	label.text = turn_order.active.skill_array[3].description
	line_end.text = ""
	descwindow.visible = true

func _on_Skill_mouse_exited():
	descwindow.visible = false


