extends Control

onready var fade = $Fade
onready var menuanim = $MenuAnim
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	InventoryData.item_data["Inv1"] = "none"
	InventoryData.item_data["Inv2"] = "none"
	InventoryData.item_data["Inv3"] = "none"
	InventoryData.item_data["Inv4"] = "none"
	InventoryData.item_data["Inv5"] = "none"
	InventoryData.item_data["Inv6"] = "none"
	MenuMusic.play_menu_music()
	fade.play("fade")
	menuanim.play("menu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Quit_pressed():
	get_tree().quit()


func _on_Start_pressed():
	fade.play_backwards("fade")
	yield(get_tree().create_timer(2.5), "timeout")
	get_tree().change_scene("res://CharSelect.tscn")
	

