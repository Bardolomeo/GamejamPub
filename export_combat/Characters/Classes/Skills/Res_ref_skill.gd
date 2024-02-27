extends Resource

class_name BaseSkill

export(float, 0.0, 2.0) var hit_rate
export var damage : int
export var usage : int
export var max_usage : int
export (String, "melee", "ranged") var _range : String
export (String, "single", "aoe", "ally", "multiattack", "single_wsb", "single_wtb", "aoe_wsb", "aoe_wtb") var target : String
export (String, "stun", "poison", "weak", "slow", 
		"haste", "regen", "attack", "cure", "stren", "random_nerf", "miss_health", "guard") var effect : String

export var skill_name : String
export var description : String

