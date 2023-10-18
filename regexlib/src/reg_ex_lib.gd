class_name RegExLib
extends RefCounted


static func split(pattern : String, subject : String):
	var r = RegEx.new()
	r.compile(pattern)

	var result = []

	var matches = r.search_all(subject)
	if matches.size() > 0:
		var beginning = 0
		for rematch in matches:
			result.append(subject.substr(beginning, rematch.get_start() - beginning))
			beginning = rematch.get_end()
		var lastMatch = matches.pop_back()
		result.append(subject.substr(lastMatch.get_end(), subject.length()))
	else:
		result.append(subject)
	return result
