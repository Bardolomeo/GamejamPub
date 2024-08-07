extends Node

var item_data = {}

func _ready():
	var fileItem = File.new()
	fileItem.open("res://Datas/Inventory.json", File.READ)
	var itemJson = JSON.parse(fileItem.get_as_text())
	fileItem.close()
	item_data = itemJson.result	
