extends Button

onready var spriteCh = $AnimatedSquad
var current_member = "none"

func _ready():
	spriteCh.play(current_member)

func load_sprite(string : String):
	current_member = string
