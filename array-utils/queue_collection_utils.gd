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

extends CollectionUtils
class_name QueueCollectionUtils

var _max_length : int = -1


func _init():
	super()


func get_max_length() -> int:
	return self._max_length


func set_max_length(max_length : int) -> QueueCollectionUtils:
	self._max_length = max_length
	return self


func push(value) -> QueueCollectionUtils:
	if self.length >= 0 and self.last() == value:
		return

	if self.length == self.get_max_length():
		self.pop()

	self.add(value)
	self.last()
	return self


func pop():
	var value = self.get_by_index(0)
	self.remove_by_index(0)
	return value
