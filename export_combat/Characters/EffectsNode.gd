extends Node


onready var job : Job = $".."
var p_guard : float = 1
var p_speed : float
var p_stren : float
var p_color : Color = Color(1,1,1)
var turn_done = 0
export var stun : int = 0
export var poison : int = 0
export var weak : int = 0
export var stren : int = 0
export var slow : int = 0
export var haste : int = 0
export var regen : int = 0
export var guard : int = 0

func _process(delta):
	if stun == 1:
		$"..".sprite2d.stop()
		
func set_stun(target): 
	target.effects.stun = 1
	target.sprite2d.stop()
	target.sprite2d.self_modulate = Color(1.5,1.5,1.5)

func check_stun():
		if stun == 1:
			stun = 0
			$"../AnimatedSprite".self_modulate = Color(1,1,1)
			$"../AnimatedSprite".play("default")
			yield(get_tree().create_timer(1), "timeout")
			$"../../.."._on_Button_turn_next()
			return 1
		return 0
		
func set_poison(target):
	target.effects.poison += 3
	target.sprite2d.self_modulate = Color8(255, 0, 255)

func check_poison():
		if poison > 1:
			poison -= 1
			job.stats.hp -= 5
			$"../DoSkill".show_damage(job, 5)
#			if job.stats.hp <= 0:
#				$"/root/CombatContainer/Combat/winscreen/winlose".check_combat_over()
			if poison == 1:
				$"../AnimatedSprite".self_modulate = Color(1,1,1)
				poison -= 1

func set_regen(target): 
	target.effects.regen += 3 
	target.sprite2d.self_modulate = Color8(0, 255, 0)

func check_regen():
		if regen > 1:
			regen -= 1
			if job.stats.hp + 5 > job.stats.hp_max:
				job.stats.hp += job.stats.hp_max - job.stats.hp
				$"../DoSkill".show_heal($"..", job.stats.hp_max - job.stats.hp)
			else:
				job.stats.hp += 5
				$"../DoSkill".show_heal($"..", 5)
			if regen == 1:
				$"../AnimatedSprite".self_modulate = Color(1,1,1)
				regen -= 1
				
func set_haste(target): 
	if target.effects.slow == 1 && target.effects.haste == 1:
		target.effects.p_speed = target.stats.speed
	target.effects.haste += 3
	target.stats.speed *= 1.3
	target.sprite2d.self_modulate = Color.yellow
	$"../..".char_arr.sort_custom($"../..", "speed_compar")
	var char_arr = $"../..".char_arr
	print(char_arr[char_arr.find(target)].stats.speed)
	if char_arr.find(target) > char_arr.find(self):
		$"../../..".act_ind = char_arr.find(target) - 1

func check_haste():
		if haste > 0:
			haste -= 1
		if haste == 1:
			$"..".stats.speed = p_speed
			$"..".sprite2d.self_modulate = Color(1,1,1)

func set_slow(target):
	p_color = $"..".sprite2d.self_modulate
	if target.effects.haste == 1 && target.effects.slow == 1:
		target.effects.p_speed = target.stats.speed
	target.effects.slow += 3
	target.stats.speed /= 1.3
	target.sprite2d.self_modulate = Color8(227, 169, 126)

func check_slow():
		if slow > 0:
			slow -= 1
		if slow == 1:
			$"..".stats.speed = p_speed
			$"../AnimatedSprite".self_modulate = Color(1,1,1)

func set_stren(target):
	if target.effects.stren == 1 && target.effects.weak == 1:
		target.effects.p_stren = target.stats.atk_mult
	target.effects.stren += 3
	target.stats.atk_mult = 1.3
	target.sprite2d.scale = Vector2(1.3, 1.3)

func check_stren():
		if stren > 1 && weak == 0:
			stren -= 1
			$"..".stats.atk_mult = 1.3
		elif stren > 1 && weak > 0:
			stren -= 1
			$"..".stats.atk_mult = 1
		elif stren == 0:
			stren -= 1
		if stren == 1 && weak == 0:
			$"..".stats.atk_mult = 1
			$"../AnimatedSprite".scale = Vector2(1, 1)
		elif stren == 1 && weak > 0:
			$"..".stats.atk_mult = 0.7
			$"../AnimatedSprite".scale = Vector2(1, 1)	
		if stren == 1:
			stren -= 1	

func set_weak(target):
	if target.effects.weak == 1 && target.effects.stren == 1:
		target.effects.p_stren = target.stats.atk_mult
	target.effects.weak += 3
	target.stats.atk_mult = 0.7
	target.sprite2d.scale = Vector2(0.7, 0.7)

func check_weak():
		if weak > 1 && stren == 0:
			weak -= 1
			$"..".stats.atk_mult = 0.7
		elif weak > 1 && stren > 0:
			weak -= 1
			$"..".stats.atk_mult = 1
		elif weak == 0:
			weak -= 1
		if weak == 1 && stren == 0:
			$"..".stats.atk_mult = 1
			$"../AnimatedSprite".scale = Vector2(1, 1)
		elif weak == 1 && stren > 0:
			$"..".stats.atk_mult = 1.3
			$"../AnimatedSprite".scale = Vector2(1, 1)
		if weak == 1:
			weak -= 1
func f_guard():
	if guard == 1:
		guard = 0
		$"../AnimatedSprite".self_modulate = Color(1,1,1)
		$"..".stats.def_mult = 1
		return 
	guard = 1
	p_color = $"../AnimatedSprite".self_modulate
	$"../AnimatedSprite".self_modulate = Color8(121, 127, 189)
	yield(get_tree().create_timer(0.1), "timeout")
	$"../AnimatedSprite".self_modulate = Color8(0, 50, 100)
	yield(get_tree().create_timer(0.1), "timeout")
	$"../AnimatedSprite".play("defense")
	$"../AnimatedSprite".self_modulate = Color8(121,127,189)
	p_guard = $"..".stats.def_mult
	$"..".stats.def_mult = 2.0

func color_manager():
	if guard != 0:
		$"../AnimatedSprite".self_modulate = Color8(121,127,189)
	elif regen != 0:
		$"../AnimatedSprite".self_modulate = Color8(0, 255, 0)
	elif poison != 0:
		$"../AnimatedSprite".self_modulate = Color8(255, 0, 255)
	elif stun != 0:
		$"../AnimatedSprite".self_modulate = Color(1.5, 1.5, 1.5)
	elif haste != 0:
		$"../AnimatedSprite".self_modulate = Color.yellow
	elif slow != 0:
		$"../AnimatedSprite".self_modulate = Color.orange
	elif stren != 0:
		$"../AnimatedSprite".scale = Vector2(1.3, 1.3)
	elif weak != 0:
		$"../AnimatedSprite".scale = Vector2(0.7, 0.7)
	if (guard + regen + poison + stun + haste + slow + stren + weak) == 0:
		$"../AnimatedSprite".self_modulate = Color.white
		$"../AnimatedSprite".scale = Vector2(1, 1)
