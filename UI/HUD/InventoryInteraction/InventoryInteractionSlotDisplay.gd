extends Control

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var displayItem = null

func _ready():
	display_item(null)
	Global.connect("inventory_closed", self, "_on_inventory_close")
	get_parent().connect("crafted", self, "_ended_crafting")

func display_item(item):
	displayItem = item
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
	
	if displayItem is Item:
		var dragPreview = inventory.gen_drag_preview(displayItem)
	
		set_drag_preview(dragPreview)
		var drag = drag_data(displayItem, item_index)
	  
		display_item(null)
		print(drag)
		return drag
	display_item(null)

func drag_data(item, _item_index):
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = -1
		get_parent().time_left = -1.0
		get_parent().start_time = -1.0
		inventory.drag_data = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	display_item(data.item)
	get_parent().emit_signal("start_crafting", data.item, get_parent().get_child(1 - get_index()).get_item())

func _ended_crafting(_item, _second_item, item_ratio):
	if get_index() <  len(item_ratio):
		displayItem.amount -= item_ratio[get_index()]
	if displayItem == null or displayItem.amount < 1:
		display_item(null)
	else: 
		display_item(displayItem)

func _on_inventory_close():
	if displayItem != null: inventory.add_item(displayItem)
	display_item(null)

func get_item():
	return displayItem
