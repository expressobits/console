class_name BaseRegexCheckedConsoleType
extends BaseConsoleType


var _pattern : String
var _regex : RegEx


func _init(name : String, pattern : String):
	super(name)
	self._pattern = pattern
	self._regex = RegEx.new()
	self._regex.compile(self._pattern)


func check(value) -> Check:
	return Check.OK if self._reextract(value) else Check.FAILED


func _reextract(value):
	var rematch = self._regex.search(value)

	if rematch and rematch is RegExMatch:
		return rematch.get_string()

	return null
