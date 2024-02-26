extends Node2D

onready var label = $Label
onready var player = $AnimationPlayer


func _on_AnimationPlayer_animation_finished(anim):
	self.queue_free()
