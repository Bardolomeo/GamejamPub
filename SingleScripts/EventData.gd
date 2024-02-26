extends Node

var event_data = {}

func _ready():
	var fileEvent = File.new()
	fileEvent.open("res://Datas/Events.json", File.READ)
	var eventJson = JSON.parse(fileEvent.get_as_text())
	fileEvent.close()
	event_data = eventJson.result	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
