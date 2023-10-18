class_name CommandService
extends RefCounted


var _console
var _command_collection = CommandCollection.new()


func _init(console):
	self._console = console


func values() -> Iterator:
	return self._command_collection.get_value_iterator()


func create(command_name : String, target, target_name = null) -> CommandBuilder:
	return CommandBuilder.new(self._console, self, command_name, target, target_name)


# @param    String   command_name
# @param    Command  command
# @returns  bool
func set(command_name, command):
	if !self._command_collection.contains_key(command_name):
		self._command_collection.set(command_name, command)
		return true
	else:
		return false


# @param    String   command_name
# @returns  Command|null
func get(command_name):
	return self._command_collection.get(command_name)


func find(command_name : String):
	return self._command_collection.find(command_name)


func remove(command_name : String):
	return self._command_collection.remove(command_name)


func autocomplete(command_name : String) -> String:
	var commands = self.find(command_name)

	if commands.length == 1:
		return commands.get_by_index(0).get_name()

	var autocomplete_result_str = command_name
	var autocomplete_result_str_len = len(autocomplete_result_str)

	var letter
	var letter_i = autocomplete_result_str_len

	while commands.length:
		for command in commands.get_value_iterator():
			var cmd_name = command.get_name()

			if letter_i >= len(cmd_name):
				return autocomplete_result_str

			var compare_to_letter = cmd_name[letter_i]

			if letter == null:
				letter = compare_to_letter

			if letter != compare_to_letter:
				return autocomplete_result_str

		autocomplete_result_str += letter
		autocomplete_result_str_len += 1
		letter = null
		letter_i += 1

	return command_name
