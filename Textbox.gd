extends CanvasLayer

onready var container = $TextContainer
onready var start = $TextContainer/MarginContainer/HBoxContainer/LineStart
onready var end = $TextContainer/MarginContainer/HBoxContainer/LineEnd
onready var content = $TextContainer/MarginContainer/HBoxContainer/Label

enum State {
	READY,
	READING,
	FINISHED
}

const READ_RATE = 0.05

# Called when the node enters the scene tree for the first time.

var current_state = State.READY
var content_queue = []
var textboxes = 0
signal textbox_done
signal change_bg

func _ready():
	print("Starting state: ready")
	hide_textbox()

func _process(_delta):
	match current_state:
		State.READY:
			if !content_queue.empty():
				display_content()
			elif content_queue.empty():
				hide()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				content.percent_visible = 1.0
				$Tween.stop_all()
				# end.text = ">"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
				textboxes = textboxes + 1
				if textboxes == 2 || textboxes == 4:
					emit_signal("change_bg")
				if content_queue.empty():
					emit_signal("textbox_done")

func queue_content(next_content):
	content_queue.push_back(next_content)

func hide_textbox():
	start.text = ""
	end.text = ""
	content.text = ""
	container.hide()

func show_text():
	container.show()
#	start.text = "#"

func display_content():
	var next_content = content_queue.pop_front()
	content.text = next_content
	content.percent_visible = 0.0
	change_state(State.READING)
	show_text()
	$Tween.interpolate_property(content, "percent_visible", 0.0, 1.0, len(next_content) * READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tween_tween_all_completed():
#	end.text = ">"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to ready")
		State.READING:
			print("Changing state to reading")
		State.FINISHED:
			print("Changing state to finished")
