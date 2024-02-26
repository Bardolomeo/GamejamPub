extends Node

var ch_data = {}

func _ready():
	var fileEvent = File.new()
	fileEvent.open("res://Datas/Characters.json", File.READ)
	var eventJson = JSON.parse(fileEvent.get_as_text())
	fileEvent.close()
	ch_data = eventJson.result	
