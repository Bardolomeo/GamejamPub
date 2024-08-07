extends Node

class_name CharacterStats

export var hp_max : int
export var speed : float
export var gold : int
export var job : String
export var hp : int
export var atk_mult : float
var is_enemy : bool
var is_boss : bool
var difficulty : int
export var def_mult : float
export var speed_mult : float
var party_member : String = "null"

func initialize(stats : StartingStats):
	hp_max = stats.hp_max
	speed = stats.speed
	gold = stats.gold
	job = stats.job
	hp = hp_max
	is_enemy = stats.is_enemy
	atk_mult = stats.atk_mult
	def_mult = stats.def_mult
	speed_mult = stats.speed_mult
	if is_enemy :
		is_boss = stats.is_boss
