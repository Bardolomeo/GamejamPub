extends Control

var SkillSpec: HBoxContainer
var open: bool = false
func _ready():
	SkillSpec = $SkillSpec


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Skill1_pressed():
	if not open:
		SkillSpec.show()
		open = true
	else:
		SkillSpec.hide()
		open = false


func _on_Skill2_pressed():
	if not open:
		SkillSpec.show()
		open = true
	else:
		SkillSpec.hide()
		open = false


func _on_Skill3_pressed():
	if not open:
		SkillSpec.show()
		open = true
	else:
		SkillSpec.hide()
		open = false
