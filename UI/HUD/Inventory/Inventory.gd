extends Resource
class_name Inventory

var drag_data = null
var mouse = null
var hideSlot = true

signal items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null,
	null, null, null, null, null, null, null,
	null, null, null, null, null, null, null,
	null, null, null
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item.duplicate()
	items[item_index].amount = item.amount
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
				items[i] = item.duplicate()
				Global.emit_signal("itembar_changed")
				return true
	
	var loop_item = item.duplicate()
	loop_item.amount = item.amount
	while loop_item.amount > 0:
		loop_item.amount = int(floor(loop_item.amount))
		for i in items.size():
			if items[i] is Item && items[i].name == loop_item.name && items[i].amount != item.max_stack_value:
				if loop_item.amount + items[i].amount > item.max_stack_value:
					loop_item.amount -= item.max_stack_value - items[i].amount
					items[i].amount = item.max_stack_value
				else:
					items[i].amount = items[i].amount + loop_item.amount
					loop_item.amount -= loop_item.amount
				emit_signal("items_changed", [i])
				break
				
			if items[i] == null:
				if loop_item.amount > item.max_stack_value:
					items[i] = item.duplicate()
					items[i].amount = item.max_stack_value
					loop_item.amount -= item.max_stack_value
				else:
					items[i] = item.duplicate()
					items[i].amount = loop_item.amount % item.max_stack_value
					loop_item.amount -= loop_item.amount % item.max_stack_value
				emit_signal("items_changed", [i])
				break
	return true
	

func adda_item(item):
	if item.is_tool:
		for n in 3:
			var i = items.size() - 3 + n;
			if items[i] == null:
				items[i] = item.duplicate()
				Global.emit_signal("itembar_changed")
				return true
	
	for n in floor(item.amount / item.max_stack_value + 1):
		var item_changed = false
		for i in items.size():
			if items[i] == null:
				items[i] = item.duplicate()
				if item.amount < item.max_stack_value:
					items[i].amount = item.amount % item.max_stack_value
				else:
					items[i].amount =  item.max_stack_value
				emit_signal("items_changed", [i])
				item_changed = true
				break
		if item_changed == false:
			return false
		item.amount -= item.max_stack_value
	
	return true


func make_items_unique():
	var unique_items = []
	for item in items:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items


func gen_drag_preview(i):
	var dragPreview = load("res://UI/HUD/Inventory/DragPreview.tscn").instance() 
	dragPreview.get_node("TextureRect").texture = i.texture
	if i.amount > 1:
		dragPreview.get_node("TextureRect/Label").text = str(i.amount)
	else:
		dragPreview.get_node("TextureRect/Label").text = ""
	var xPos = 0 - dragPreview.get_node("TextureRect").texture.get_size()[0] / 2
	var yPos = 0 - dragPreview.get_node("TextureRect").texture.get_size()[1] / 2
	dragPreview.get_node("TextureRect").rect_position = Vector2(xPos, yPos)
	return dragPreview
