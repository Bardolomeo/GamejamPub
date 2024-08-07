extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		reset_stats()
		get_tree().change_scene("res://Menu.tscn")

func reset_stats():
	GlobalVar.stage = 1
	GlobalVar.choiceNum = 0
	GlobalVar.choiceCap = 10
	GlobalVar.gold = 0
	GlobalVar.day = 0
	GlobalVar.secondmember = "none"
	GlobalVar.thirdmember = "none"
	GlobalVar.ancientRune = "none"
	GlobalVar.enchFeather = "none"
	GlobalVar.monocle = "none"
	GlobalVar.oldTome = "none"
	GlobalVar.oldtomeflag = 0
	GlobalVar.pocketDagger = "none"
	GlobalVar.regenStone = "none"
	InventoryData.item_data["Inv1"] = "none"
	InventoryData.item_data["Inv2"] = "none"
	InventoryData.item_data["Inv3"] = "none"
	InventoryData.item_data["Inv4"] = "none"
	InventoryData.item_data["Inv5"] = "none"
	InventoryData.item_data["Inv6"] = "none"
	GlobalVar.partypoison = false
	GlobalVar.partyweak = false
	GlobalVar.partyslow = false
	GlobalVar.partyregen = false
	GlobalVar.partyhaste = false
	GlobalVar.partystrength = false
	GlobalVar.enemystun = false
	GlobalVar.enemyweak = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
