extends Control

onready var container = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer
onready var start = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineStart
onready var end = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/LineEnd
onready var content = $HBoxContainer/TextWindow/MarginContainer/HBoxContainer/Label
onready var pause_menu = $PauseMenu
onready var choice1 = $HBoxContainer/InputWindow/VBoxContainer/Choice1
onready var choice2 = $HBoxContainer/InputWindow/VBoxContainer/Choice2
onready var chosen = $HBoxContainer/InputWindow/ChoiceMade
var paused = false
var choice_made = false
var which_choice = "X"
var fight_start = "res://export_combat/CombatContainer.tscn"
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
var n

func pause():
	if paused == false:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
		
	paused = !paused

func _ready():
	randomize()
	n = randi() % 18
	print(n)
	print("Starting state: ready")
	hide_textbox()
	choice1.text = EventData.event_data[str(n)]["choices"]["A"]["desc"]
	choice2.text = EventData.event_data[str(n)]["choices"]["B"]["desc"]
	queue_content(EventData.event_data[str(n)]["scenario"])

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
			if Input.is_action_just_pressed("ui_accept") && choice_made == true:
				process_outcome(which_choice)

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

func _on_Choice1_pressed():
	choice_made = true
	which_choice = "A"
	choice1.visible = false
	choice2.visible = false
	chosen.visible = true
	change_state(State.READY)
	hide_textbox()
	queue_content(EventData.event_data[str(n)]["choices"]["A"]["result"])

func _on_Choice2_pressed():
	choice_made = true
	which_choice = "B"
	choice1.visible = false
	choice2.visible = false
	chosen.visible = true
	change_state(State.READY)
	hide_textbox()
	queue_content(EventData.event_data[str(n)]["choices"]["B"]["result"])

func process_outcome(which_choice : String):
	if EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "none":
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start":
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_party_weak":
		GlobalVar.partyweak = true
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_party_poison":
		GlobalVar.partypoison = true
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_party_slow":
		GlobalVar.partyslow = true
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "fight_start_enemy_stun":
		GlobalVar.enemystun = true
		get_tree().change_scene(fight_start)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "gold_gain20":
		GlobalVar.gold = GlobalVar.gold + 20
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "small_heal":
		#Heal party 15%
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "medium_heal":
		#Heal party 30%
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "one_member_full_heal":
		#Fully heal a random party member
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "medium_hurt":
		#Damage party 30% of current life (to avoid killing party members from it)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "party_weak":
		#Inflict weakness on the party in the next combat
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "party_poison":
		#Inflict poison on the party in the next combat
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "enemy_weak":
		#Inflict weakness on all enemies in the next combat
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "lose_trinket":
		#Lose random trinket (if there are any)
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "regen_stone":
		#Gain Regen Stone trinket
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "monocle":
		#Gain Monocle trinket
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "stage_2_longer_plus_medium_heal":
		#Stage gets longer by 2 scenes, 30% heal on all party members
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "party_poison_plus_party_fullpp":
		#Refills all PP and inflicts poison on all party members for the next fight
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "drain_pp_plus_party_weak":
		#Drains 50% PP (rounded up) and inflicts weak on the party in the next combat
		get_tree().change_scene(next_scene)
	elif EventData.event_data[str(n)]["choices"][which_choice]["outcome"] == "old_tome_plus_fight_start":
		#Gain Old Tome Trinket and start a fight
		get_tree().change_scene(next_scene)
	else:
		get_tree().change_scene(next_scene)
