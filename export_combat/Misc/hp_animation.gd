extends AnimationPlayer

onready var label = $hp_label

func _ready():
	self.play("HP")
	advance(0)
