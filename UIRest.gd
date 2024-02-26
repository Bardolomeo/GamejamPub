extends Control

onready var container = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer
onready var start = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var end = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineEnd
onready var content = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var pause_menu = $PauseMenu
onready var choice1 = $HBoxContainer/InputWindow/VBoxContainer/Choice1
onready var choice2 = $HBoxContainer/InputWindow/VBoxContainer/Choice2
onready var chosen = $HBoxContainer/InputWindow/ChoiceMade
onready var anim = $AnimationPlayer
var paused = false
var choice_made = false
var next_scene = "res://Gui.tscn"

enum State {
	READY,
	READING,
	FINISHED
}

const READ_RATE = 0.05

# Called when the node enters the scene tree for the first time.

var current_state = State.READY
var content_queue = []
var textboxes = 0

func pause():
	if paused == false:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused

func _ready():
	full_life()
	print("Starting state: ready")
	anim.play("fountain")
	hide_textbox()
	queue_content("You come upon a glorious fountain in the middle of a misty square. The tranquil sounds of flowing water calm your nerves. You drink your fill and take a moment to rest, breathing a sigh of relief.")
	queue_content("Your party is fully rested!")

func full_life():
	GlobalVar.firstmemberlife = CharactersData.ch_data[GlobalVar.firstmember]["vita"]
	GlobalVar.firstmemberfirstmovePP = SkillsData.skills_data[GlobalVar.firstmember]["Skill1"]["usage"]
	GlobalVar.firstmembersecondmovePP = SkillsData.skills_data[GlobalVar.firstmember]["Skill2"]["usage"]
	GlobalVar.firstmemberthirdmovePP = SkillsData.skills_data[GlobalVar.firstmember]["Skill3"]["usage"]
	if GlobalVar.secondmember != "none":
		GlobalVar.secondmemberlife = CharactersData.ch_data[GlobalVar.secondmember]["vita"]
		GlobalVar.secondmemberfirstmovePP = SkillsData.skills_data[GlobalVar.secondmember]["Skill1"]["usage"]
		GlobalVar.secondmembersecondmovePP = SkillsData.skills_data[GlobalVar.secondmember]["Skill2"]["usage"]
		GlobalVar.secondmemberthirdmovePP = SkillsData.skills_data[GlobalVar.secondmember]["Skill3"]["usage"]
	if GlobalVar.thirdmember != "none":
		GlobalVar.thirdmemberlife = CharactersData.ch_data[GlobalVar.thirdmember]["vita"]
		GlobalVar.thirdmemberfirstmovePP = SkillsData.skills_data[GlobalVar.thirdmember]["Skill1"]["usage"]
		GlobalVar.thirdmembersecondmovePP = SkillsData.skills_data[GlobalVar.thirdmember]["Skill2"]["usage"]
		GlobalVar.thirdmemberthirdmovePP = SkillsData.skills_data[GlobalVar.thirdmember]["Skill3"]["usage"]

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		pause()
	match current_state:
		State.READY:
			if !content_queue.empty():
				display_content()
			elif content_queue.empty():
				container.hide()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				content.percent_visible = 1.0
				$Tween.stop_all()
				# end.text = ">"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
				textboxes = textboxes + 1
				if textboxes == 2:
					get_tree().change_scene(next_scene)

func queue_content(next_content):
	content_queue.push_back(next_content)

func hide_textbox():
	start.text = ""
	end.text = ""
	content.text = ""
	container.hide()

func show_text():
	container.show()
#	start.text = "#"

func display_content():
	var next_content = content_queue.pop_front()
	content.text = next_content
	content.percent_visible = 0.0
	change_state(State.READING)
	show_text()
	$Tween.interpolate_property(content, "percent_visible", 0.0, 1.0, len(next_content) * READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tween_tween_all_completed():
#	end.text = ">"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to ready")
		State.READING:
			print("Changing state to reading")
		State.FINISHED:
			print("Changing state to finished")
