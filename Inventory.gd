extends Control

var inventory_slot = preload("res://Temp/ItemSlot.tscn")

onready var gridContainer = get_node("VBoxContainer/ScrollContainer/GridContainer")

func _ready():
	for key in TrinketsData.item_data.keys():
		var inv_slot = inventory_slot.instance()

		if "Name" in TrinketsData.item_data[key]:
			var item_name = TrinketsData.item_data[key]["Name"]
			print(item_name)

			var icon_node = inv_slot.get_node("obj")
			if icon_node != null:
				icon_node.set_texture(load("res://Assets/Trinkets/" + item_name + ".png"))
				icon_node.connect("mouse_entered", self, "_on_obj_mouse_entered")
				icon_node.connect("mouse_exited", self, "_on_obj_mouse_exited")
				print("Percorso dell'icona:", "res://Assets/Trinkets/" + item_name + ".png")
			else:
				print("Il nodo 'Icon' non esiste in ItemSlot.tscn.")

			gridContainer.add_child(inv_slot, true)

func _on_obj_mouse_entered():
	pass
func _on_obj_mouse_exited():
	pass
