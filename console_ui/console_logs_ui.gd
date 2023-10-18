class_name ConsoleLogsUI
extends RichTextLabel

@export var timed_messages : float = 0.0

var logs : Array
var times : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Console.write_message.connect(append_text_custom.bind())
	Console.clear_message.connect(clear.bind())
	
	# Allow selecting console text
	set_selection_enabled(true)
	# Follow console output (for scrolling)
	set_scroll_follow(true)
	bbcode_enabled = true


func append_text_custom(message : String):
	text += message
	if timed_messages > 0.0:
		logs.append(message)
		times.append(timed_messages)
		

func _process(delta : float):
	for i in times.size():
		times[i] -= delta

	if times.size() > 0:
		if times[0] < 0.0:
			remove_text(logs[0])
			logs.remove_at(0)
			times.remove_at(0)


func remove_text(message : String):
	text = text.substr(message.length(), text.length() - message.length())
	
