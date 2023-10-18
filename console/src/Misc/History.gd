class_name ConsoleHistory
extends QueueCollectionUtils


# @param  int  maxLength
func _init(maxLength):
	self.set_max_length(maxLength)


# @returns  History
func print_all():
	var i = 1
	if length > 1:
		Console.write_line('[color=#ff66ff]=== HISTORY ===[/color]')
	for command in self.get_value_iterator():
		Console.write_line(\
			'[b]' + str(i) + '.[/b] [color=#ffff66][url=' + \
			command + ']' + command + '[/url][/color]')
		i += 1

	return self
