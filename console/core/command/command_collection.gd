class_name CommandCollection
extends CollectionUtils


func _init(collection : Dictionary = {}):
	super(collection)


func find(command_name : String) -> CommandCollection:
	var filter_cb_fn = CallbackBuilder.new(self).set_method("_find_match").bind([command_name]).build()
	return self.filter(filter_cb_fn)


func _find_match(match_key : String, key : String, value, _i : int, _collection : CommandCollection) -> bool:
	return key.begins_with(match_key)
