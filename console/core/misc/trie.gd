class_name ConsoleTrie
extends RefCounted

var _root

# Trie data structure class
func _init():
	self._root = TrieNode.new()


# If not present, inserts key into trie.
# If the key is prefix of trie node, just marks leaf node.
func insert(key : String, value):
	var current_node = self._root

	var length = len(key)
	for level in range(length):
		var index = key[level]

		# if current character is not present
		if not current_node.has_child(index):
			current_node.initialize_child_at(index)

		current_node = current_node.get_child(index)

	if current_node.value:
		return

	current_node.value = value


# Search key in the trie.
# Returns true if key presents in trie, else false.
func has(key : String) -> bool:
	return !!self.get(key)


# Search key in the trie.
# Returns value if key presents in trie, else null.
# @param    String  key
# @returns  Variant|null
func get(key):
	var current_node = self._root

	var length = len(key)
	for level in range(length):
		var index = key[level]

		if not current_node.has_child(index):
			return null

		current_node = current_node.get_child(index)

	return current_node.value



class TrieNode:

	var _children : Dictionary
	var value


	# Trie node class
	func _init():
		self._children = {}
		self.value = null


	func get_children() -> Dictionary:
		return self._children


	func has_child(index : int) -> bool:
		return index in self._children


	func get_child(index : int) -> Dictionary:
		return self._children[index]


	func initialize_child_at(index : int):
		self._children[index] = TrieNode.new()
