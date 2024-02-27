extends Node2D

onready var label = $Label
onready var player = $AnimationPlayer


func _on_AnimationPlayer_animation_finished(anim):
	$Label.rect_position = Vector2(-20, -50)
	self.queue_free()
