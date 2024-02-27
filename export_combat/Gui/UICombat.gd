extends Control

onready var skills = $SkillWindow
onready var skilldesc = $SkillWindow/DescWindow
onready var txtpanel = $HBoxContainer/TextWindow/Panel
onready var line_start = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var label = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var line_end = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineEnd
onready var pause_menu = $PauseMenu
var paused = false


func _ready():
	$Fade.play("fade")
	if GlobalVar.day == 1:
		self.self_modulate = Color.darkslateblue
	line_start.text = ""
	label.text = ("It's " + 
				 $"/root/CombatContainer/Combat/Turn Order".active.stats.job
				 + "'s turn!\n\n\n\nWhat will you do?")
	line_end.text = ""

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		pause()

func pause():
	if paused == false:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused

func _on_Skills_pressed():
	if !$"/root/CombatContainer/Combat/Turn Order".active.stats.is_enemy:
		hide_txt()
		skills.visible = true
		skills.set_skills()

func _on_Attack_pressed():
	if !$"/root/CombatContainer/Combat/Turn Order".active.stats.is_enemy:
		label.text = "Who will you attack?"
		show_txt()

func _on_Defend_pressed():
	if !$"/root/CombatContainer/Combat/Turn Order".active.stats.is_enemy:
		if (return_from_skills()):
			return
		label.text = "You prepare to defend yourself!"
		skills.visible = false
		skilldesc.visible = false
		show_txt()
#	desc.visible = false

func hide_txt():
	line_start.visible = false
	label.visible = false
	line_end.visible = false
	txtpanel.visible = false

func show_txt():
	line_start.visible = true
	label.visible = true
	line_end.visible = true
	txtpanel.visible = true

func return_from_skills():
	if $"/root/CombatContainer/SkillWindow".visible :
		$"/root/CombatContainer".show_txt()
		$"/root/CombatContainer/SkillWindow".visible = false
		return 1
	return 0

func set_effect(effect, target):
	match effect :
		"guard":
			$"Combat/Turn Order".active.effects.f_guard()
		"stun":
			$"Combat/Turn Order".active.effects.set_stun(target)
		"poison":
			$"Combat/Turn Order".active.effects.set_poison(target)
		"regen":
			$"Combat/Turn Order".active.effects.set_regen(target)
		"haste":
			$"Combat/Turn Order".active.effects.set_haste(target)
		"slow":
			$"Combat/Turn Order".active.effects.set_slow(target)
		"stren":
			$"Combat/Turn Order".active.effects.set_stren(target)
		"weak":
			$"Combat/Turn Order".active.effects.set_weak(target)

func _disable_commands():
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Attack").disabled = 	!get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Attack").disabled
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Skills").disabled = !get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Skills").disabled
	get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Defend").disabled = !get_tree().root.get_node("CombatContainer/HBoxContainer/InputWindow/VBoxContainer/Defend").disabled

func custom_timer(seconds, node : Node, f_to_execute : String):
	var timer = Timer.new()
	# Set timer interval
	timer.set_wait_time(seconds)

	# Set it as repeat
	timer.set_one_shot(true)

	# Connect its timeout signal to the function you want to repeat
	timer.connect("timeout", node, f_to_execute)

	# Add to the tree as child of the current node
	add_child(timer)

	timer.start()
