## 
# The MIT License (MIT)

# Copyright (c) 2023 Feo (k2kra) Wu

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class_name GodotLogs
extends Node
#Monitor built-in logs

signal error_msg_received(msg:String)
signal warning_msg_received(msg:String)
signal info_msg_received(msg:String)

const UPDATE_INTERVAL := 0.1
const ERROR_MSG_PREFIX := "USER ERROR: "
const WARNING_MSG_PREFIX := "USER WARNING: "
#Any logs with three spaces at the beginning will be ignored.
const IGNORE_PREFIX := "   " 

@export var timer:Timer

var godot_log:FileAccess

func _ready():
	var file_logging_enabled = ProjectSettings.get("debug/file_logging/enable_file_logging") or ProjectSettings.get("debug/file_logging/enable_file_logging.pc")
	if !file_logging_enabled:
		push_warning("You have to enable file logging in order to use engine log monitor!")
		return
	
	var log_path = ProjectSettings.get("debug/file_logging/log_path")
	godot_log = FileAccess.open(log_path, FileAccess.READ)

	timer.timeout.connect(_read_data)
	timer.wait_time = UPDATE_INTERVAL
	timer.one_shot = false
	timer.start()

func _read_data():
	while godot_log.get_position() < godot_log.get_length():
		var new_line = godot_log.get_line()
		if new_line.begins_with(IGNORE_PREFIX):
			continue
		if new_line.begins_with(ERROR_MSG_PREFIX):
			Console.write_line("[color=#ff6666]"+new_line.trim_prefix(ERROR_MSG_PREFIX)+"[/color]")
		elif new_line.begins_with(WARNING_MSG_PREFIX):
			Console.write_line(new_line.trim_prefix(WARNING_MSG_PREFIX))
		else:
			Console.write_line(new_line)
