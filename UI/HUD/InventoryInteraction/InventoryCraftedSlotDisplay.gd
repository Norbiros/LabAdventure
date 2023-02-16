extends Control


onready var itemTextureRect = $ItemTextureRect
onready var itemAmountLabel = $ItemTextureRect/ItemAmountLabel
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var displayItem = null


func _ready():
	get_parent().connect("show_crafting_recepies", self, "_show_crafting")
	Global.connect("inventory_closed", self, "_on_inventory_close")
	display_item(null)

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
		return drag
	display_item(null)

func drag_data(item, _item_index):
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = -1
		inventory.drag_data = data
		return data
		
func _show_crafting(item):
	display_item(null)
	if get_index() == 1 and item is Item and item.name == "IronOre":
		var i = load("res://Items/Resources/IronIngot.tres")
		i.amount = floor(item.amount / 2) + 1
		display_item(i)

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	inventory.add_item(data.item)

func _on_inventory_close():
	if displayItem != null: inventory.add_item(displayItem)
	displayItem = null
