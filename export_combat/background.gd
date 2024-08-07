extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVar.stage == 1:
		self.play("stage1")
	if GlobalVar.stage == 2:
		self.play("stage2")
	if GlobalVar.stage == 3:
		self.play("stage3")



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
