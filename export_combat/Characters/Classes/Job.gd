extends Node2D

class_name Job

export var starting_stats : Resource
export (Array, Resource) var skill_array
export (PackedScene) var skill_scene
onready var stats = $Stats
onready var skills = $Skills
onready var do_skill = $DoSkill
export onready var sprite2d = $AnimatedSprite
onready var player = $AnimationPlayer
onready var effects = $Effects


func _ready() :
	stats.initialize(starting_stats)
	set_health_bar()
	if starting_stats.is_enemy :
		$"./Bar".visible = false
	for n in skill_array :
		var new_skill = skill_scene.instance()
		new_skill.initialize(n)
		skills.add_child(new_skill)
	if !$AnimatedSprite.connect("animation_finished", self, "_set_idle") :
		_set_idle()

func _process(_delta):
	$"./Bar/ProgressBar".value = stats.hp
	if stats.hp <= 0 :
		sprite2d.play("hurt")
		sprite2d.speed_scale = 0.2
		sprite2d.self_modulate = Color(0.1, 0.1, 0.1)
		
func _set_idle():
	sprite2d.play("default")

func set_health_bar() :
	var scene = load("res://export_combat/Characters/HealthBar.tscn")
	var health_bar = scene.instance()
	add_child(health_bar)
	health_bar.get_node("ProgressBar").max_value = stats.hp_max
	health_bar.get_node("ProgressBar").value = stats.hp
