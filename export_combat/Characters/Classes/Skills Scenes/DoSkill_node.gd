extends SkillsNode

class_name DoSkillNode

signal round_end

var sk_value : Array
	
func _ready():
	randomize()
	pass

func find_skill(name : String, is_enemy : bool) :
	var i = 0
	var skill : SkillsNode
	var skills = $"../Skills".get_children()
	var targets : Array
	
	for sk in skills :
		sk_value.append(sk.damage)
		sk.damage = sk.damage * $"../..".active.stats.atk_mult
	while skills[i].skill_name != name && i < skills.size():
		i += 1
	if i < skills.size() :
		skill = skills[i]
	else :
		skill.initialize(skills[0])
	if players_array() != [null]:
		targets = select_target(skill, is_enemy)
	if targets == [null]:
		return 
	if is_enemy :
		execute(skill, targets, sk_value)

func select_target(skill, is_enemy):
	var targets : Array
	var not_end : bool
	match skill.target:
		"single":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
				else:
					targets = [null]
			else :
				for n in enemies_array($"../..".char_arr):
					if n.stats.hp > 0:
						not_end = 1
				if not_end:
					targets.append_array(enemy_target_single(skill))
				else:
					targets = [null]
		"aoe":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
			else:
				targets.append_array(enemy_target_aoe(skill))
		"multiattack":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
			else :
				targets.append_array(enemy_target_single(skill))
		"ally":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_enemy_target(skill.target))
			else :
				targets.append_array(player_target_single(skill))
		"single_wsb":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
				else:
					targets = [null]
			else :
				for n in enemies_array($"../..".char_arr):
					if n.stats.hp > 0:
						not_end = 1
				if not_end:
					targets.append_array(enemy_target_single(skill))
				else:
					targets = [null]
		"aoe_wsb":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
			else:
				targets.append_array(enemy_target_aoe(skill))
		"single_wtb":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
				else:
					targets = [null]
			else :
				for n in enemies_array($"../..".char_arr):
					if n.stats.hp > 0:
						not_end = 1
				if not_end:
					targets.append_array(enemy_target_single(skill))
				else:
					targets = [null]
		"aoe_wtb":
			if is_enemy :
				if players_array() != null:
					targets.append_array(random_player_target(skill.target))
			else:
				targets.append_array(enemy_target_aoe(skill))
		_	:
				targets = [null]
	return targets

func random_player_target(type : String):
	var player_arr = players_array()
	
	if player_arr.size() > 1:
		match type :
			"single":
					return [player_arr[randi() % (player_arr.size() - 1) + 1]]
			"aoe":
				return player_arr
			"multiattack":
					return [player_arr[randi() % (player_arr.size() - 1) + 1]]
			"single_wsb":
					return [player_arr[randi() % (player_arr.size() - 1) + 1]]
			"aoe_wsb":
				return player_arr
			"single_wtb":
					return [player_arr[randi() % (player_arr.size() - 1) + 1]]
			"aoe_wsb":
				return player_arr
		return [null]
	
func random_enemy_target(type : String):
	var enemies_arr = enemies_array($"../..".char_arr)
	var enemies : Array
	
	for n in enemies_arr:
		if n.stats.hp > 0:
			enemies.append(n)
	if enemies.size() > 0:
		return [enemies[randi() % enemies.size()]]
				
func players_array():
	var char_arr : Array
	char_arr = $"../..".get_children()
	var player_arr : Array = [null]
	for n in char_arr :
		if !n.stats.is_enemy && n.stats.hp > 0:
			player_arr.append(n)
	return player_arr

func execute(skill : SkillsNode, targets : Array, sk_value : Array):
	var hit_or_miss : float
	
	if targets == [null]:
		return
	if skill.usage > 0 || skill.usage == -1 :
		if $"..".stats.is_enemy :
			enemy_blink_blue($"..")
	skill_range(skill)
	skill_target(skill, targets, sk_value)
	
func post_wait_execute(skill, targets, sk_value):
	if skill.usage > 0 :
		skill.usage -= 1
	var i = 0
	for n in $"../Skills".get_children():
		n.damage = sk_value[i]
		i += 1
	if $"/root/CombatContainer/Combat/winscreen/winlose".check_combat_over():
		return
	$"/root/CombatContainer/Combat/TurnNext"._on_Button_turn_next()

func is_multiattack(skill : SkillsNode, targets : Array):
	var hit_or_miss : float
	var or_color : Array

	if skill.target == "multiattack":
		for target in targets:
			or_color.append(target.self_modulate)
		for i in 3:
			for target in targets :
				hit_or_miss = (skill.hit_rate + (1 - target.stats.speed * target.stats.speed_mult)) / 2
				if rand_range(0.0, 1.0) < hit_or_miss :
					var prov : int = skill.damage / target.stats.def_mult
					target.stats.hp -= prov
					show_damage(target, prov)
					target.sprite2d.play("hurt")
					enemy_blink_red(target)
					$"/root/CombatContainer".set_effect(skill.effect, target)
				else :
					on_miss(target)
			yield(get_tree().create_timer(0.5), "timeout")
		for color in or_color:
			targets[or_color.find(color)].self_modulate = color
		

func is_single_or_aoe(skill : SkillsNode, targets : Array):
	var hit_or_miss : float
	for target in targets :
		if target.stats.hp > 0:
			hit_or_miss = (skill.hit_rate + (1 - target.stats.speed * target.stats.speed_mult)) / 2
			if rand_range(0.0, 1.0) < hit_or_miss :
				var prov : int
				if skill.effect == "miss_health" :
					prov = $"../..".active.stats.hp_max - $"../..".active.stats.hp
				else:
					prov = skill.damage / target.stats.def_mult
				target.stats.hp -= prov
				if skill.effect == "random_nerf":
					set_random_effect(skill.effect, target)
					skill.effect = "random_nerf"
				else:
					$"/root/CombatContainer".set_effect(skill.effect, target)
				show_damage(target, prov)
				target.sprite2d.play("hurt")
				enemy_blink_red(target)
			else :
				on_miss(target)

func is_single_or_aoe_wsbuff(skill : SkillsNode, targets : Array):
	var hit_or_miss : float
	for target in targets :
		if target.stats.hp > 0:
			hit_or_miss = (skill.hit_rate + (1 - target.stats.speed * target.stats.speed_mult)) / 2
			if rand_range(0.0, 1.0) < hit_or_miss :
				var prov : int
				prov = skill.damage / target.stats.def_mult
				target.stats.hp -= prov
				show_damage(target, prov)
				target.sprite2d.play("hurt")
				enemy_blink_red(target)
			else :
				on_miss(target)
	$"/root/CombatContainer".set_effect(skill.effect, $"..")
	
func is_single_or_aoe_wtbuff(skill : SkillsNode, targets : Array):
	var hit_or_miss : float
	for target in targets :
		if target.stats.hp > 0:
			hit_or_miss = (skill.hit_rate + (1 - target.stats.speed * target.stats.speed_mult)) / 2
			if rand_range(0.0, 1.0) < hit_or_miss :
				var prov : int = skill.damage / target.stats.def_mult
				target.stats.hp -= prov
#				$"../../../winscreen/winlose".check_combat_over()
				show_damage(target, prov)
				target.sprite2d.play("hurt")
				enemy_blink_red(target)
			else :
				on_miss(target)
	var allies : Array
	if $"..".stats.is_enemy:
		for n in enemies_array($"../..".char_arr):
			if n.stats.hp > 0:
				allies.append(n)
	else:
		allies = players_array()
	for ally in allies:
		$"/root/CombatContainer".set_effect(skill.effect, ally)

func is_ally_target(skill : SkillsNode, targets : Array):
	var hit_or_miss : float
	for target in targets :
		if target.stats.hp > 0:
			if target.stats.hp + skill.damage <= target.stats.hp_max:
				show_heal(target, skill.damage)
				target.stats.hp += skill.damage
			else:
				show_heal(target, target.stats.hp_max - target.stats.hp)
				target.stats.hp += target.stats.hp_max - target.stats.hp
			$"/root/CombatContainer".set_effect(skill.effect, target)
			ally_blink_green(target)

func player_target_single(skill : SkillsNode):
	var button_array : Array
	var players = players_array()
	for n in players :
		if n != null:
			n.player.play("SELECTION")
			button_array.append(add_button_single(n, skill))
	for n in button_array:
		n.connect("pressed", self, "_destroy_buttons", [button_array, players])
	return button_array

func enemy_target_single(skill : SkillsNode):
	var button_array : Array
	var enemies = enemies_array($"../..".char_arr)
	for n in enemies :
		if n.stats.hp > 0:
			n.player.play("SELECTION")
			button_array.append(add_button_single(n, skill))
	for n in button_array:
		n.connect("pressed", self, "_destroy_buttons", [button_array, enemies])
	return button_array
		
func enemy_target_aoe(skill : SkillsNode):
	var button_array : Array
	var enemies = enemies_array($"../..".char_arr)
	
	for n in enemies :
		if n.stats.hp > 0:
			n.player.play("SELECTION")	
			button_array.append(add_button_aoe(n, enemies, skill))
	for n in button_array:
		n.connect("pressed", self, "_destroy_buttons", [button_array, enemies])
#	_disable_commands()
	return button_array
	

func enemies_array(char_arr : Array):
	var array : Array
	for n in char_arr :
		if is_instance_valid(n):
			if n.stats.is_enemy :
				array.append(n)
	return array

func _destroy_buttons(array : Array, enemies : Array):
	for n in enemies:
		if n != null:
			n.player.play("DEFAULT")
	for n in array:
		n.queue_free()
#	_disable_commands()
	
func add_button_single(n : Job, skill : SkillsNode):
	var button = Button.new()
	n.add_child(button)
	button.rect_size = Vector2(128, 128)
	button.rect_position = Vector2(-64, -64)
	button.self_modulate = Color(1,1,1,0)
	var ret = [n]
	button.connect("pressed", self, "execute", [skill, ret, sk_value])
	return (button)

func add_button_aoe(n : Job, targets : Array, skill : SkillsNode):
	var button = Button.new()
	n.add_child(button)
	button.rect_size = Vector2(128, 128)
	button.rect_position = Vector2(-64, -64)
	button.self_modulate = Color(1,1,1,0)
	button.connect("pressed", self, "execute", [skill, targets, sk_value])
#	button.connect("pressed", get_tree().root.get_node("CombatContainer/Combat/TurnNext"), "_on_Button_turn_next")
	return (button)

func enemy_blink_red(enemy : Job):
	var or_color =  enemy.sprite2d.self_modulate
	enemy.sprite2d.self_modulate = Color(0.9,0.5,0.5)
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.sprite2d.self_modulate = Color(0.5,0.1,0.1)
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.sprite2d.self_modulate = Color(0.9,0.5,0.5)
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.sprite2d.self_modulate = or_color
	
func show_damage(target : Job, damage : int):
	var scene = load("res://export_combat/Misc/hp_animation_2.tscn")
	var animation_node = scene.instance()
	target.add_child(animation_node)
	animation_node.label.rect_position = target.position
	var damage2 : int = damage / target.stats.def_mult
	animation_node.label.text = String(damage2)
	animation_node.position += Vector2(-60, -50)
	animation_node.player.play("HP")
	
func show_heal(target, damage):
	var scene = load("res://export_combat/Misc/hp_animation_2.tscn")
	var animation_node = scene.instance()
	target.add_child(animation_node)
	animation_node.label.rect_position = target.position
	animation_node.label.text = String(damage)
	animation_node.position += Vector2(-60, -50)
	animation_node.player.play("HPup")

func _remove_label():
	var label = $"../hp"
	label.queue_free()

func on_miss(target : Job):
	var scene = load("res://export_combat/Misc/hp_animation_2.tscn")
	var animation_node = scene.instance()
	target.add_child(animation_node)
	animation_node.label.rect_position = target.position
	animation_node.label.text = "MISS"
	animation_node.position += Vector2(-60, -50)
	animation_node.player.play("HP")
	animation_node.label.add_color_override("font_color", Color(1, 1, 1))
	
func enemy_blink_blue(enemy : Job):
	var or_color =  enemy.sprite2d.self_modulate
	enemy.sprite2d.self_modulate = Color(0.5,0.6,0.8)
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.sprite2d.self_modulate = Color(0.1,0.2,0.4)
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.sprite2d.self_modulate = Color(0.5,0.6,0.8)
	yield(get_tree().create_timer(0.1), "timeout")
	enemy.sprite2d.self_modulate = or_color
	
func ally_blink_green(target : Job):
	var or_color =  target.sprite2d.self_modulate
	target.sprite2d.self_modulate = Color(0.5,0.9,0.5)
	yield(get_tree().create_timer(0.1), "timeout")
	target.sprite2d.self_modulate = Color(0.1,0.5,0.1)
	yield(get_tree().create_timer(0.1), "timeout")
	target.sprite2d.self_modulate = Color(0.5,0.9,0.5)
	yield(get_tree().create_timer(0.1), "timeout")
	target.sprite2d.self_modulate = or_color

func set_random_effect(effect, target):
	match randi() % 4:
		0:
			effect = "stun"
		1:
			effect = "poison"
		2:
			effect = "weak"
		3:
			effect = "slow"
	$"/root/CombatContainer".set_effect(effect, target)

func skill_range(skill):
	if skill._range == "melee" :
		$"../AnimatedSprite".play("attack")
#		_disable_commands()
#		yield(get_tree().create_timer(0.8), "timeout")
#		_disable_commands()
	else :
		$"../AnimatedSprite".play("attackr")
#		_disable_commands()
#		yield(get_tree().create_timer(0.8), "timeout")
#		_disable_commands()

func skill_target(skill, targets, skvalue):
	if skill.target == "single" || skill.target == "aoe":
		is_single_or_aoe(skill, targets)
	elif skill.target == "multiattack":
		is_multiattack(skill, targets)
	elif skill.target == "ally":
		is_ally_target(skill, targets)
	elif skill.target == "single_wsb" || skill.target == "aoe_wsb":
		is_single_or_aoe_wsbuff(skill, targets)
	elif skill.target == "single_wtb" || skill.target == "aoe_wtb":
		is_single_or_aoe_wtbuff(skill, targets)
	post_wait_execute(skill, targets, sk_value)
	
