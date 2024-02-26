extends Node

class_name SkillsNode

export(float, 0.0, 1.0) var hit_rate
export var damage : int
export var usage : int
export var max_usage : int
export var multiplier : float
export (String, "melee", "ranged") var _range : String
export (String, "single", "aoe", "ally") var target : String
export (String, "paralys", "bleed", "weakened", "blind", 
		"slowed", "haste", "regen") var effect : String

export var skill_name : String
export var description : String

func initialize(skill : BaseSkill) :
	hit_rate = skill.hit_rate
	damage = skill.damage
	usage = skill.usage
	max_usage = skill.max_usage
	skill_name = skill.skill_name
	description = skill.description
	_range = skill._range
	target = skill.target
	effect = skill.effect
