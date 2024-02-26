extends Control
onready var descwindow = $DescWindow
onready var line_start = $DescWindow/HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var label = $DescWindow/HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var line_end = $DescWindow/HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart

func _ready():
	line_start.text = ""
	label.text = ""
	line_end.text = ""

func _on_Skill1_pressed():
	line_start.text = ""
	label.text = "This is a test, please remain calm."
	line_end.text = ""
	descwindow.visible = true

func _on_Skill2_pressed():
	line_start.text = ""
	label.text = "This is the second skill description, hello!"
	line_end.text = ""
	descwindow.visible = true

func _on_Skill3_pressed():
	line_start.text = ""
	label.text = "This is the third skill description. It's the boring one."
	line_end.text = ""
	descwindow.visible = true
