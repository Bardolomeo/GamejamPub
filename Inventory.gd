extends Control

var inventory_slot = preload("res://Temp/ItemSlot.tscn")
onready var item = get_node("item")
onready var itemName = get_node("item/itemName")
onready var itemDesc = get_node("item/itemDesc")
onready var gridContainer = get_node("VBoxContainer/ScrollContainer/GridContainer")

var currentHoveredItem = null

func _ready():

	for key in InventoryData.item_data.keys():
		var inv_slot = inventory_slot.instance()

		if "Name" in InventoryData.item_data[key]:
			var item_name = InventoryData.item_data[key]["Name"]
			var item_desc = InventoryData.item_data[key]["desc"]
			var icon_node = inv_slot.get_node("obj")
			print(item_name)
			if icon_node != null && item_name != "none":
				icon_node.set_texture(load("res://Assets/Trinkets/" + item_name + ".png"))
				inv_slot.connect("mouse_entered", self, "_on_obj_mouse_entered", [item_name, item_desc])
				inv_slot.connect("mouse_exited", self, "_on_obj_mouse_exited")

			gridContainer.add_child(inv_slot, true)
	gridContainer.connect("mouse_exited", self, "_on_grid_mouse_exited")

func _on_obj_mouse_entered(item_name, item_desc):
	item.show()
	itemName.text = item_name
	itemDesc.text = item_desc
	currentHoveredItem = item_name 

func _on_obj_mouse_exited():
	item.hide()
	itemName.text = ""
	itemDesc.text = ""
	currentHoveredItem = null

func _on_grid_mouse_exited():
	if currentHoveredItem == null:
		item.hide()
		itemName.text = ""
		itemDesc.text = ""

