extends Control

onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var displayItem = null

func _ready():
	display_item(null)
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
	get_parent().emit_signal("show_crafting_recepies", null)
	
	if displayItem is Item:
		var dragPreview = inventory.gen_drag_preview(displayItem)
	
		set_drag_preview(dragPreview)
		var drag = drag_data(displayItem, item_index)
		display_item(null)
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
	get_parent().emit_signal("start_crafting", data.item, 10.0)

func _ended_crafting(item):
	get_parent().emit_signal("show_crafting_recepies", item)
	inventory.emit_signal("items_changed", [0])
	Global.emit_signal("itembar_changed")
	inventory.drag_data = null 
	inventory.hideSlot = true
	display_item(null)
