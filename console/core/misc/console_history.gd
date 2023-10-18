class_name ConsoleHistory
extends Node

var collection : QueueCollectionUtils
@export var max_length : int = 32

func _ready():
	collection = QueueCollectionUtils.new()
	collection.set_max_length(max_length)
	Console.add_command('history', self, 'print_all')\
		.set_description('Print all previous commands used during the session.')\
		.register()
	Console.raw_input.connect(collection.push.bind())


func print_all() -> ConsoleHistory:
	var i = 1
	if collection.length > 1:
		Console.write_line('[color=#ff66ff]=== HISTORY ===[/color]')
	for command in collection.get_value_iterator():
		Console.write_line(\
			'[b]' + str(i) + '.[/b] [color=#ffff66][url=' + \
			command + ']' + command + '[/url][/color]')
		i += 1

	return self
