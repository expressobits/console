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

extends RefCounted
class_name ArrayUtils

static func to_array(value) -> Array:
	if is_array(value):
		return value

	elif typeof(value) != TYPE_NIL:
		return [ value ]

	return []


static func is_array(value) -> bool:
	return typeof(value) >= TYPE_ARRAY


static func to_dict(value) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY:
		return value

	var d = {}

	if typeof(value) != TYPE_NIL:
		if is_array(value):
			for i in value.size():
				d[i] = value[i]
		else:
			d[0] = value

	return d


static func flatten(in_array : Array, out_array : Array = [], depth : int = -1) -> Array:
	assert(typeof(in_array) == TYPE_ARRAY, "qc/array-utils: Utils: in_array must be an array")

	for i in in_array.size():
		if is_array(in_array[i]) and depth > 0:
			flatten(in_array[i], out_array, depth - 1)
		else:
			out_array.append(in_array[i])

	return out_array
