extends CenterContainer

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
		if item.amount > 1:
			itemTextureRect.show()
			itemAmountLabel.text = str(item.amount)
		elif item.amount == 0:
			itemTextureRect.hide()
		else:
			itemTextureRect.show()
			itemAmountLabel.text = ""
	else:
		itemTextureRect.texture = load("res://Items/Textures/empty.png")
		itemAmountLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	
	if item is Item:
		var dragPreview = inventory.gen_drag_preview(item)
	
		set_drag_preview(dragPreview)
		return drag_data(item, item_index)

func drag_data(item, item_index):
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		inventory.drag_data = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.name == data.item.name:
		if my_item.amount + data.item.amount <= my_item.max_stack_value:
			my_item.amount += data.item.amount
			inventory.emit_signal("items_changed", [my_item_index])
		else:
			inventory.set_item(data.item_index, data.item)
	else:
		if inventory.hideSlot == true:
			inventory.swap_item(my_item_index, data.item_index)
		inventory.set_item(my_item_index, data.item)
	Global.emit_signal("itembar_changed")
	inventory.drag_data = null 
	inventory.hideSlot = true

var touchingMouse = false
	
func _input(_event):
	if get_index() == inventory.mouse && Input.is_action_pressed("inventory_split") && inventory.drag_data == null:
		var item_index = get_index()
		var i = inventory.items[item_index].duplicate()
		var el = inventory.items[item_index].duplicate() 
		if i is Item:
			var amount = inventory.items[item_index].amount
			if amount / 2 == 0 || amount - amount / 2 == 0 or amount == 1:
				return
			i.amount = floor(amount / 2)
			el.amount = amount - floor(amount / 2)
			
			
			var dragPreview = inventory.gen_drag_preview(i)
			
			inventory.hideSlot = false
			inventory.items[item_index] = el
			inventory.emit_signal("items_changed", [item_index])
			
			force_drag(drag_data(i, item_index), dragPreview)


func _on_InventorySlotDisplay_mouse_entered():
	inventory.mouse = get_index()

func _on_InventorySlotDisplay_mouse_exited():
	inventory.mouse = get_index()
