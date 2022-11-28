extends Resource
class_name Inventory

signal items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null,
	null, null, null, null, null, null, null,
	null, null, null, null, null, null, null,
	null, null, null
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	return previousItem

func swap_item(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])

func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem

func add_item(item):
	if item.is_tool:
		for n in 3:
			var i = items.size() - 3 + n;
			if items[i] == null:
				items[i] = item
				Global.emit_signal("itembar_changed")
				return true
	for n in items.size():
		if items[n] == null:
			items[n] = item
			emit_signal("items_changed", [n])
			return true
	return false
