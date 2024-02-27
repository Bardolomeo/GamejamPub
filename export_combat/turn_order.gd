extends Node2D

class_name TurnOrder

var active : Job
var char_arr : Array
var scene : PackedScene
var fight_difficulty = 4
var stage = 1
var co = 0

func _init():
	var characters : Array
	characters = get_children()
	characters.sort_custom(self, "speed_compar")
	return characters

func _process (delta):
	if co == 0:
		co = $"../winscreen/winlose".check_combat_over()
	pass

func _ready():
	randomize()
	var cyc = 0
	enemies_gen()
	$"..".set_party()
	for pg in $"..".characs :
		cyc += instance_player_scene(cyc, pg)
	char_arr = _init()
	active = char_arr[0]

func instance_player_scene(cyc, pg):
	var job : String
	job = CharactersData.ch_data[pg]["classe"]
	scene = load("res://export_combat/Characters/Classes/" + job + ".tscn")
	var pg1 = scene.instance()
	add_child(pg1)
	set_char_stats(pg1, pg)
	if cyc == 0 :
		pg1.position += Vector2(500, 250)
	elif cyc == 1 :
		pg1.position += Vector2(650, 400)
	elif cyc == 2 :
		pg1.position += Vector2(500, 550)
	return 1

func set_char_stats(pg1, pg):
	pg1.stats.hp = CharactersData.ch_data[pg]["vita"]
	pg1.skill_array[1].usage = SkillsData.skills_data[pg]["Skill1"]["usage"]
	pg1.skill_array[2].usage = SkillsData.skills_data[pg]["Skill2"]["usage"]
	pg1.skill_array[3].usage = SkillsData.skills_data[pg]["Skill3"]["usage"]

func speed_compar(a, b):
	return a.stats.speed * a.stats.speed_mult > b.stats.speed * b.stats.speed_mult

func enemies_gen():
	var tot_cost = fight_difficulty
	var cost = 0
	var cyc = 0
	var enemies : Array =  [null]
	while (cost < tot_cost) :
		if cyc == 4:
			break
		match randi() % 3 :
			0:
				cost += load_enemy(1)
			1:
				cost += load_enemy(2)
			2:
				cost += load_enemy(3)
		cyc += 1
	for n in char_arr :
		if n.stats.is_enemy :
			enemies.append(n)
	if enemies[0] == null :
		load_enemy(1)
	enemies_position()

func enemies_position():
	var ene_arr : Array
	var cyc = 0
	for child in get_children():
		if child.starting_stats.is_enemy:
			ene_arr.append(child) 
	for ene in ene_arr :
		match cyc :
			0:
				ene.position = Vector2(1920 - 700, 250)
			1:
				ene.position = Vector2(1920 - 850, 350)
			2:
				ene.position = Vector2(1920 - 700, 450)
			3:
				ene.position = Vector2(1920 - 850, 550)
			_:
				ene.queue_free()
				get_children().erase(ene)
		cyc += 1
		
func load_enemy(type : int) :
	var enemy : Job
	match stage:
		1:
			match type:
				1:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (1)
				2:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (2)
				3:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (4)
		2:
			match type:
				1:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (1)
				2:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (2)
				3:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 4
		3:
			match type:
				1:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 1
				2:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 2
				3:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 4
