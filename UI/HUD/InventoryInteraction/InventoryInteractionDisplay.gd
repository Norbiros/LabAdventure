extends Control


func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
