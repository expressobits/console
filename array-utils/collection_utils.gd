extends ArrayUtils
class_name CollectionUtils

var _collection : Dictionary = {}
var _iterationCurrent : int = 0
var length : int :
	get:
		return _length()
	set(value):
		_set_readonly(value) 


func _init(collection : Dictionary = {}):
	self.replace_collection(collection)


func replace_collection(collection):
	self._collection = self.to_dict(collection)


func set(key, value):
	self._collection[key] = value


func add(value):
	self.set(self.length, value)


func remove(key):
	self._collection.erase(key)


# Removes the specified element from the collection, if it is found.
func remove_element(element) -> bool:
	for key in self._collection:
		if self._collection[key] == element:
			self._collection.erase(key)
			return true

	return false


func remove_by_index(index : int):
	var keys = self._collection.keys()

	if index >= 0 and index < keys.size():
		self._collection.erase(keys[index])


# Checks whether the collection contains a specific key/index.
func contains_key(key) -> bool:
	return self._collection.has(key)


# Checks whether the given element is contained in the collection.
# Only element values are compared, not keys. The comparison of
# two elements is strict, that means not only the value but also
# the type must match. For objects this means RefCounted equality.
func contains(element) -> bool:
	for key in self._collection:
		if self._collection[key] == element:
			return true

	return false


# Searches for a given element and, if found, returns the corresponding
# key/index of that element. The comparison of two elements is strict,
# that means not only the value but also the type must match.
# For objects this means RefCounted equality.
func index_of(element):
	for key in self._collection:
		if self._collection[key] == element:
			return key

	return null


# Gets the element with the given key/index.
func get(key):
	if self.contains_key(key):
		return self._collection[key]

	return null


func get_by_index(index : int):
	var keys = self._collection.keys()

	if index >= 0 and index < keys.size():
		return self._collection[keys[index]]

	return null


# Gets all keys/indexes of the collection elements.
func get_keys() -> Array:
	return self._collection.keys()


# Gets all elements.
func get_values() -> Array:
	return self._collection.values()


# Checks whether the collection is empty.
# @returns  bool
func is_empty():
	return self.length == 0


# Clears the collection.
func clear():
	self._collection = {}


# Extract a slice of `length` elements starting at
# position `offset` from the Collection.
# @param    int       offset
# @param    int|null  length
# @returns  Collection
func slice(offset : int, length = null):
	var result = get_script().new()

	if offset < self.length:
		if length == null:
			length = self.length

		var i = 0
		while length and i < self.length:
			result.set( i, self.get_by_index(offset + i) )
			length -= 1
			i += 1

	return result


# Fill an array with values.
func fill(value = null, startIndex : int = 0, length = null):
	if startIndex < self.length:
		if length == null:
			length = self.length

		while length:
			self._collection[startIndex] = value
			startIndex += 1
			length -= 1

	return self


func map(callback : AbstractCallback):
	for key in self:
		self._collection[key] = callback.call([self._collection[key], key, self._collection])

	self.first()
	return self


func filter(callback = null):
	var new_collection = self.get_script().new(self.get_collection().duplicate())

	var i = 0
	if callback:
		var call

		while i < new_collection.length:
			var key = new_collection.get_keys()[i]
			var value = new_collection.get(key)

			call = callback.call([key, value, i, new_collection])

			if !call:
				new_collection.remove_by_index(i)
			else:
				i += 1
	else:
		while i < new_collection.length:
			var value = new_collection.get_by_index(i)
			if value == null or typeof(value) == TYPE_NIL or len(value) == 0:
				new_collection.remove_by_index(i)
			else:
				i += 1

	return new_collection


# Sets the internal iterator to the first element in the collection and returns this element.
func first():
	if self.length:
		self._iterationCurrent = 0
		return self.get_by_index(self._iterationCurrent)

	return null


# Sets the internal iterator to the last element in the collection and returns this element.
func last():
	if self.length:
		self._iterationCurrent = self.length - 1
		return self.get_by_index(self._iterationCurrent)

	return null


# Gets the current key/index at the current internal iterator position.
func key():
	if self.length:
		return self._iter_get()

	return null


# Moves the internal iterator position to the next element and returns this element.
func next():
	if self.length and self._iterationCurrent < self.length - 1:
		self._iterationCurrent += 1
		return self.get_by_index(self._iterationCurrent)

	return null


# Moves the internal iterator position to the previous element and returns this element.
func previous():
	if self.length and self._iterationCurrent > 0:
		self._iterationCurrent -= 1
		return self.get_by_index(self._iterationCurrent)

	return null


# Gets the element of the collection at the current internal iterator position.
func current():
	if self.length:
		return self._collection[self._iter_get()]

	return null


func get_collection():
	return self._collection


func _length() -> int:
	if _collection == null:
		replace_collection({})
	
	return self._collection.size()


func size() -> int:
	return self._collection.size()


func _iter_init(arg) -> bool:
	self._iterationCurrent = 0
	return self._iterationCurrent < self.length


func _iter_next(arg) -> bool:
	self._iterationCurrent += 1
	return self._iterationCurrent < self.length


func _iter_get(arg = null):
	return self._collection.keys()[self._iterationCurrent]


func get_value_iterator() -> Iterator:
	return Iterator.new(self, "get_by_index")


func _set_readonly(value):
	print("qc/array-utils: Collection: Attempted to set readonly value, ignoring.")
