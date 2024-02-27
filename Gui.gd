extends Control

var path_strade = "res://Assets/Streets/"
var squad_ch = preload("res://SquadCh.tscn")
onready var gridCh = get_node("VBoxContainer/HBoxContainer1/VBoxContainer/MarginContainer/GridContainer")

onready var Choice1 = get_node("VBoxContainer/Choices/Choice1")
onready var Choice2 = get_node("VBoxContainer/Choices/Choice2")
onready var Choice3 = get_node("VBoxContainer/Choices/Choice3")
onready var sprite_c1 = $VBoxContainer/Choices/Choice1/AnimatedStreets
onready var sprite_c2 = $VBoxContainer/Choices/Choice2/AnimatedStreets
onready var sprite_c3 = $VBoxContainer/Choices/Choice3/AnimatedStreets
onready var Gold = $VBoxContainer/HBoxContainer1/VBoxContainer/HBoxContainer/Gold
onready var pause_menu = $PauseMenu
var flag = 0

var paused = false

func _ready():
	for key in SquadData.squad_data.keys():
		var ch_slot = squad_ch.instance()
		ch_slot.load_sprite(GlobalVar.firstmember)
		gridCh.add_child(ch_slot, true)
		if GlobalVar.secondmember != "none":
			var ch_slot2 = squad_ch.instance()
			ch_slot2.load_sprite(GlobalVar.secondmember)
			gridCh.add_child(ch_slot2, true)
		if GlobalVar.thirdmember != "none":
			var ch_slot3 = squad_ch.instance()
			ch_slot3.load_sprite(GlobalVar.thirdmember)
			gridCh.add_child(ch_slot3, true)

	level()
	print(str(GlobalVar.choiceNum))

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

func gold_counter(var g): 
	Gold.text = "$" + str(GlobalVar.gold)

func  next_choice(name):
	if name == "fontanag" || name == "fontanan":
		get_tree().change_scene("res://UIRest.tscn")
	elif name == "shopg" || name == "shopn":
		get_tree().change_scene("res://Shop.tscn")
	else:
		get_tree().change_scene("res://UIEvent.tscn")

func _on_Choice1_pressed():
	next_choice(sprite_c1.get_animation())

func _on_Choice2_pressed():
	GlobalVar.gold += 10
	next_choice(sprite_c1.get_animation())

func _on_Choice3_pressed():
	next_choice(sprite_c1.get_animation())

func _on_Choice1_mouse_entered():
	hover_color("c", sprite_c1)

func _on_Choice1_mouse_exited():
	hover_color("e", sprite_c1)

func _on_Choice2_mouse_entered():
	hover_color("c", sprite_c2)

func _on_Choice2_mouse_exited():
	hover_color("e", sprite_c2)
	
func _on_Choice3_mouse_entered():
	hover_color("c", sprite_c3)

func _on_Choice3_mouse_exited():
	hover_color("e", sprite_c3)


func hover_color(var color, var path_c) :
	if color == "c":	
		path_c.set_modulate(Color(0.5, 0.039215, 0.7, 2)) # Imposta il colore rosso e la trasparenza al 50%
		path_c.play("hover_animation")
	if color == "e" :
		path_c.set_modulate(Color.white) # Imposta il colore rosso e la trasparenza al 50%
		path_c.play("hover_animation")
	
	
var figlio: Node
func _on_Inv_pressed():
	var scene_tree = get_tree()
	if figlio == null:
		figlio = preload("res://Inventory.tscn").instance()
		scene_tree.current_scene.add_child(figlio)
	else:
		figlio.queue_free()
		figlio = null


func _on_Ch1_pressed():
	ChSkills(0)


func _on_Ch2_pressed():
	ChSkills(0)


func _on_Ch3_pressed():
	ChSkills(0)

func ChSkills(var key):
	var scene_tree = get_tree()
	if figlio == null:
		figlio = preload("res://Skills.tscn").instance()
		scene_tree.current_scene.add_child(figlio)
	else:
		figlio.queue_free()
		figlio = null

func randomize_street():
	var n1 = randi() % 20 + 1
	var n2 = randi() % 20 + 1
	var n3 = randi() % 20 + 1
	
	if GlobalVar.day == 0:
		n1 = randG(n1,n2,n3);
		n2 = randG(n2,n1,n3);
		n3 = randG(n3,n1,n2);
	else:
		n1 = randN(n1,n2,n3);
		n2 = randN(n2,n1,n3);
		n3 = randN(n3,n1,n2);
	sprite_c1.play("strada" + str(n1))
	sprite_c2.play("strada" + str(n2))
	sprite_c3.play("strada" + str(n3))

	
func randomize_rest(s1, s2, s3):
	var n1 = randi() % 20 + 1
	var n2 = randi() % 20 + 1
	var n3 = randi() % 20 + 1
	if GlobalVar.day == 0:
		n1 = randG(n1,n2,n3);
		n2 = randG(n2,n1,n3);
		n2 = randG(n3,n1,n2);
		sprite_c1.play("fontanag")
		GlobalVar.day = 1
	else:
		n1 = randN(n1,n2,n3);
		n2 = randN(n2,n1,n3);
		n2 = randN(n3,n1,n2);
		sprite_c1.play("fontanan")
		GlobalVar.day = 0
	sprite_c2.play("strada" + str(n1))
	sprite_c3.play("strada" + str(n2))

func randomize_shop(s1, s2, s3):
	var n1 = randi() % 20 + 1
	var n2 = randi() % 20 + 1
	if GlobalVar.day == 0:
		n1 = randG(n1,n2,0);
		n2 = randG(n2,n1,0);
		sprite_c1.play("shopg")
	else:
		n1 = randN(n1,n2,0);
		n2 = randN(n2,n1,0);
		sprite_c1.play("shopn")
	sprite_c2.play("strada" + str(n1))
	sprite_c3.play("strada" + str(n2))

	
func level():
	if GlobalVar.choiceNum < GlobalVar.choiceCap:
		GlobalVar.choiceNum += 1
		if GlobalVar.choiceNum % 4 == 0 :
			match randi() %3 + 1:
				1:
					randomize_rest(sprite_c1,sprite_c2,sprite_c3)
				2:
					randomize_rest(sprite_c2,sprite_c1,sprite_c3)
				3:
					randomize_rest(sprite_c3,sprite_c2,sprite_c1)
		elif GlobalVar.choiceNum == 5:
			match randi() %3 + 1:
				1:
					randomize_shop(sprite_c1,sprite_c2,sprite_c3)
				2:
					randomize_shop(sprite_c2,sprite_c1,sprite_c3)
				3:
					randomize_shop(sprite_c3,sprite_c2,sprite_c1)
		else:
			randomize_street()


func randN (n1, n2, n3):
	while n1 == n2 || n1 == n3 || n1 % 2 != 0:
		 n1 = randi() % 20 + 1
	return n1
	
func randG (n1, n2, n3):
	while n1 == n2 || n1 == n3 || n1 % 2 == 0:
		 n1 = randi() % 20 + 1
	return n1
