extends Node2D

class_name TurnOrder

var active : Job
var char_arr : Array
var scene : PackedScene
var fight_difficulty = 4
var co = 0

func _init():
	var characters : Array
	characters = get_children()
	characters.sort_custom(self, "speed_compar")
	return characters

func _process (delta):
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
	combat_start()

func instance_player_scene(cyc, pg):
	var job : String
	job = CharactersData.ch_data[pg]["classe"]
	scene = load("res://export_combat/Characters/Classes/" + job + ".tscn")
	var pg1 = scene.instance()
	add_child(pg1)
	set_char_stats(pg1, cyc)
	if cyc == 0 :
		pg1.position += Vector2(500, 250)
	elif cyc == 1 :
		pg1.position += Vector2(650, 400)
	elif cyc == 2 :
		pg1.position += Vector2(500, 550)
	return 1

func set_char_stats(pg1, cyc):
	match cyc:
		0:
			pg1.stats.hp = GlobalVar.firstmemberlife #CharactersData.ch_data[pg]["vita"]
			pg1.skill_array[1].usage = GlobalVar.firstmemberfirstmovePP
			pg1.skill_array[2].usage = GlobalVar.firstmembersecondmovePP
			pg1.skill_array[3].usage = GlobalVar.firstmemberthirdmovePP
			pg1.stats.party_member = GlobalVar.firstmember
		1:
			pg1.stats.hp = GlobalVar.secondmemberlife #CharactersData.ch_data[pg]["vita"]
			pg1.skill_array[1].usage = GlobalVar.secondmemberfirstmovePP
			pg1.skill_array[2].usage = GlobalVar.secondmembersecondmovePP
			pg1.skill_array[3].usage = GlobalVar.secondmemberthirdmovePP
			pg1.stats.party_member = GlobalVar.secondmember
		2:
			pg1.stats.hp = GlobalVar.thirdmemberlife #CharactersData.ch_data[pg]["vita"]
			pg1.skill_array[1].usage = GlobalVar.thirdmemberfirstmovePP
			pg1.skill_array[2].usage = GlobalVar.thirdmembersecondmovePP
			pg1.skill_array[3].usage = GlobalVar.thirdmemberthirdmovePP
			pg1.stats.party_member = GlobalVar.thirdmember

func speed_compar(a, b):
	return a.stats.speed * a.stats.speed_mult > b.stats.speed * b.stats.speed_mult

func enemies_gen():
	var tot_cost = fight_difficulty
	var cost = 0
	var cyc = 0
	var enemies : Array =  [null]
	if GlobalVar.choiceNum == GlobalVar.choiceCap:
		load_boss()
		enemies_position()
		return
	while (cost < tot_cost - 1) :
		if cyc == 4:
			break
		match randi() % 3 :
			0:
				cost += load_enemy(1)
			1:
				cost += load_enemy(2) #ERA 2
			2:
				cost += load_enemy(3) #ERA 3
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

func load_boss():
	var enemy : Job
	match GlobalVar.stage:
		1:
			scene = load("res://export_combat/Characters/Enemies/The Blood Lust.tscn")
			enemy = scene.instance()
			add_child(enemy)
		2:
			scene = load("res://export_combat/Characters/Enemies/The Swarm.tscn")
			enemy = scene.instance()
			add_child(enemy)
		3:
			scene = load("res://export_combat/Characters/Enemies/The Deep Dark.tscn")
			enemy = scene.instance()
			add_child(enemy)
	enemy.sprite2d.scale = Vector2(1.7, 1.7)

func combat_start():
#	check_trinket()
	check_events()
	
func check_events():
	if GlobalVar.partypoison:
		GlobalVar.partypoison = 0
		for n in party_array():
			$"/root/CombatContainer".set_effect("poison", n)
	if GlobalVar.partyweak:
		GlobalVar.partyweak = 0
		for n in party_array():
			$"/root/CombatContainer".set_effect("weak", n)
	if GlobalVar.partyslow:
		GlobalVar.partyslow = 0
		for n in party_array():
			$"/root/CombatContainer".set_effect("slow", n)
	if GlobalVar.partyregen:
		GlobalVar.partyregen = 0
		for n in party_array():
			$"/root/CombatContainer".set_effect("regen", n)
	if GlobalVar.partyhaste:
		GlobalVar.partyhaste = 0
		for n in party_array():
			$"/root/CombatContainer".set_effect("haste", n)
	if GlobalVar.partystrength:
		GlobalVar.partystrength = 0
		for n in party_array():
			$"/root/CombatContainer".set_effect("stren", n)
	if GlobalVar.enemystun:
		GlobalVar.enemystun = 0
		for n in enemy_array():
			$"/root/CombatContainer".set_effect("stun", n)
	if GlobalVar.enemyweak:
		GlobalVar.enemyweak = 0
		for n in enemy_array():
			$"/root/CombatContainer".set_effect("weak", n)

func party_array():
	var arr : Array
	for n in char_arr:
		if n.stats.hp > 0 && !n.stats.is_enemy:
			arr.append(n)
	return arr

func enemy_array():
	var arr : Array
	for n in char_arr:
		if n.stats.hp > 0 && n.stats.is_enemy:
			arr.append(n)
	return arr

func load_enemy(type : int) :
	var enemy : Job
	match GlobalVar.stage:
		1:
			match type:
				1:
					scene = load("res://export_combat/Characters/Enemies/Aracno.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (1)
				2:
					scene = load("res://export_combat/Characters/Enemies/The Cultist.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (2)
				3:
					scene = load("res://export_combat/Characters/Enemies/The Worm.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (4)
		2:
			match type:
				1:
					scene = load("res://export_combat/Characters/Enemies/The Caged.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (1)
				2:
					scene = load("res://export_combat/Characters/Enemies/The Afflicted.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return (2)
				3:
					scene = load("res://export_combat/Characters/Enemies/The Maw.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 4
		3:
			match type:
				1:
					scene = load("res://export_combat/Characters/Enemies/The Afflicted.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 1
				2:
					match randi() % 2:
						0:
							scene = load("res://export_combat/Characters/Enemies/The Doll.tscn")
							enemy = scene.instance()
						1:
							scene = load("res://export_combat/Characters/Enemies/The Crawler.tscn")
							enemy = scene.instance()
					add_child(enemy)
					return 2
				3:
					scene = load("res://export_combat/Characters/Enemies/The Drawned.tscn")
					enemy = scene.instance()
					add_child(enemy)
					return 4
