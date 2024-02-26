extends Node

var skills_data = {}

func _ready():
	var fileEvent = File.new()
	fileEvent.open("res://Datas/Skills.json", File.READ)
	var eventJson = JSON.parse(fileEvent.get_as_text())
	fileEvent.close()
	skills_data = eventJson.result	
