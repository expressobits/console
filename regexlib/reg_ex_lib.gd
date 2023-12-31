# The MIT License (MIT)
#Copyright (c) 2019 - Sergei Zhuravlev
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

## Usefull regex stuff.
## Todo:
## - Cache compiled patterns in `split` method.
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
