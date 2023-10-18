class_name ConsoleLine
extends LineEdit


const COMMANDS_SEPARATOR = ';'

const RECOMMANDS_SEPARATOR = '(?<!\\\\)' + COMMANDS_SEPARATOR

const COMMAND_PARTS_SEPARATOR = ' '

const QUOTES = [ '"', "'" ]

const SCREENERS = [ '\\/' ]

const COMMAND_PREFIX = '/'

# @var  String|null
var _tmp_user_entered_command

# @var  String
var _current_command


func _ready():
	# Console keyboard control
	self.set_process_input(true)
	self.caret_blink = true

	self.connect("text_submitted", execute)


# @param  InputEvent
func _gui_input(event):
	pass
	#if Console.consume_input and self.has_focus():
		#accept_event()


# @var  SceneTreeTimer
var _autocomplete_triggered_timer

# @param  InputEvent  e
func _input(e):
	# Don't process input if console is not visible
	if !is_visible_in_tree():
		return

	# Show next line in history
	if Input.is_action_just_pressed(ConsoleDefaultActions.CONSOLE_HISTORY_UP):
		self._current_command = Console.history.current()
		Console.history.previous()

		if self._tmp_user_entered_command == null:
			self._tmp_user_entered_command = self.text

	# Show previous line in history
	if Input.is_action_just_pressed(ConsoleDefaultActions.CONSOLE_HISTORY_DOWN):
		self._current_command = Console.history.next()

#		if self._current_command != null and self._tmp_user_entered_command != null:
#				self._current_command = self._tmp_user_entered_command
#				self._tmp_user_entered_command = null

	# Autocomplete on TAB
	if Input.is_action_just_pressed(ConsoleDefaultActions.CONSOLE_AUTOCOMPLETE):
		if self._autocomplete_triggered_timer and self._autocomplete_triggered_timer.get_time_left() > 0:
			self._autocomplete_triggered_timer = null
			var actual_text = self.text
			if actual_text.begins_with(COMMAND_PREFIX):
				actual_text = actual_text.right(-1)
			var commands = Console.get_command_service().find(actual_text)
			if commands.length == 1:
				self.set_text(COMMAND_PREFIX + commands.get_by_index(0).get_name())
			elif commands.length > 1:
				Console.write_line('[color=#ffff33]=== POSSIBLE COMMANDS ===[/color]')
				for command in commands.get_value_iterator():
					var name = command.get_name()
					Console.write_line(COMMAND_PREFIX + '[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])
		else:
			self._autocomplete_triggered_timer = get_tree().create_timer(1.0, true)
			var autocompleted_command = Console.get_command_service().autocomplete(self.text)
			self.set_text(autocompleted_command)

	# Finish
	if self._current_command != null:
		self.set_text(self._current_command.getText() if self._current_command and typeof(self._current_command) == TYPE_OBJECT else self._current_command)
		self.accept_event()
		self._current_command = null


# @param    String  text
# @param    bool    move_caret_to_end
# @returns  void
func set_text(text, move_caret_to_end = true):
	self.text = text
	self.grab_focus()

	if move_caret_to_end:
		self.caret_column = text.length()


# @param    String  input
# @returns  void


func execute(raw_input : String):
	if raw_input.is_empty():
		return
	
	var input : String = raw_input
	if Console.use_prefix_for_commands:
		if not input.begins_with(COMMAND_PREFIX):
			if not Console.default_command.is_empty() and Console.default_command.length():
				input = COMMAND_PREFIX + Console.default_command + COMMAND_PARTS_SEPARATOR + input
			else:
				self.clear()
				return
		input = input.right(-1)

	if Console.print_command_in_console:
		Console.write_line('[color=#999999]/[/color] ' + input)
		
	var parsedCommands : Array = _parse_commands(input)

	for parsedCommand in parsedCommands:
		if parsedCommand.name.length():
			# @var  Command/Command|null
			var command = Console.get_command(parsedCommand.name)

			if command:
				Console.Log.debug('Executing `' + parsedCommand.command + '`.')
				if command._arg_type == command.ArgType.STRING:
					var arg_string : String
					for i in parsedCommand.arguments.size():
						arg_string += parsedCommand.arguments[i] + COMMAND_PARTS_SEPARATOR
					parsedCommand.arguments = [ arg_string ]
				command.execute(parsedCommand.arguments)
				Console.emit_signal("command_executed", command)
			else:
				Console.write_line('Command `' + parsedCommand.name + '` not found.')
				Console.emit_signal("command_not_found", parsedCommand.name)

	Console.history.push(raw_input)
	self.clear()


# @static
# @param    String             input
# @returns  Array<Dictionary>
static func _parse_commands(input):
	var resultCommands = []

	# @var  PoolStringArray
	var rawCommands = RegExLib.split(RECOMMANDS_SEPARATOR, input)
	for rawCommand in rawCommands:
		if rawCommand:
			resultCommands.append(_parse_command(rawCommand))

	return resultCommands


# @static
# @param    String  rawCommand
# @returns  Dictionary
static func _parse_command(rawCommand, string_formatted_args := true):
	var name = ''
	var arguments : Array[String]

	var beginning = 0  # int
	var openQuote  # String|null
	var isInsideQuotes = false  # boolean
	var subString  # String|null
	for i in rawCommand.length():
		# Quote
		if rawCommand[i] in QUOTES and \
				(i == 0 or i > 0 and not rawCommand[i - 1] in SCREENERS):
			if isInsideQuotes and rawCommand[i] == openQuote:
				openQuote = null
				isInsideQuotes = false
				subString = rawCommand.substr(beginning, i - beginning)
				beginning = i + 1
			elif !isInsideQuotes:
				openQuote = rawCommand[i]
				isInsideQuotes = true
				beginning += 1

		# Separate arguments
		elif rawCommand[i] == COMMAND_PARTS_SEPARATOR and !isInsideQuotes or i == rawCommand.length() - 1:
			if i == rawCommand.length() - 1:
				subString = rawCommand.substr(beginning, i - beginning + 1)
			else:
				subString = rawCommand.substr(beginning, i - beginning)
			beginning = i + 1

		# Save separated argument
		if subString != null and typeof(subString) == TYPE_STRING and !subString.is_empty():
			if name.is_empty():
				name = subString
			else:
				arguments.append(subString)
			subString = null

	return {
		'command': rawCommand,
		'name': name,
		'arguments': arguments
	}


# @returns  void
func _set_readonly(value):
	Console.Log.warn('QC/Console/ConsoleLine: _set_readonly: Attempted to set a protected variable, ignoring.')
