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
