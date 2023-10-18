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
class_name Iterator
extends RefCounted


var _object_get_value_cb
var _object_get_length_cb
var _iteration_current_index : int = 0
var length : int :
	set(value): 
		_set_readonly(value)
	get:
		return _length()


func _init(target, get_value_field : String = "get", get_length_field : String = "size"):
	_object_get_value_cb = CallbackBuilder.new(target).set_name(get_value_field).build()
	_object_get_length_cb = CallbackBuilder.new(target).set_name(get_length_field).build()


func _length() -> int:
	return self._object_get_length_cb.call()


func _get(index):
	return self._object_get_value_cb.call([index])


# Sets the internal iterator to the first element in the collection and returns this element
func first():
	if self.length:
		self._iteration_current_index = 0
		return self._get(self._iteration_current_index)

	return null


# Sets the internal iterator to the last element in the collection and returns this element.
func last():
	if self.length:
		self._iteration_current_index = self.length - 1
		return self._get(self._iteration_current_index)

	return null


# Gets the current key/index at the current internal iterator position.
func key():
	if self.length:
		return self._iteration_current_index

	return null


# Moves the internal iterator position to the next element and returns this element.
func next():
	if self.length and self._iteration_current_index < self.length - 1:
		self._iteration_current_index += 1
		return self._get(self._iteration_current_index)

	return null


# Moves the internal iterator position to the previous element and returns this element.
func previous():
	if self.length and self._iteration_current_index > 0:
		self._iteration_current_index -= 1
		return self._get(self._iteration_current_index)

	return null


# Gets the element of the collection at the current internal iterator position.
func current():
	if self.length:
		return self._get(self._iteration_current_index)

	return null


func _iter_init(arg) -> bool:
	self._iteration_current_index = 0
	return self._iteration_current_index < self.length


func _iter_next(arg) -> bool:
	self._iteration_current_index += 1
	return self._iteration_current_index < self.length


func _iter_get(arg = null):
	return self._get(self._iteration_current_index)


func _set_readonly(value):
	print("qc/iterator: Iterator: Attempted to set readonly value, ignoring.")
