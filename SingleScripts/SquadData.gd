extends Node

var squad_data = {}

func _ready():
	var fileEvent = File.new()
	fileEvent.open("res://Datas/Squad.json", File.READ)
	var eventJson = JSON.parse(fileEvent.get_as_text())
	fileEvent.close()
	squad_data = eventJson.result	
