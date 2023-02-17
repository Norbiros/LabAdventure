extends Resource
class_name Item

export(String) var name = ""
export(String) var displayName = ""
export(String,  MULTILINE) var description = ""
export(Texture) var texture
export(bool) var is_tool
export(int) var max_stack_value = 1

var amount = 1
