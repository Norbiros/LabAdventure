extends Control

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
onready var gridContainer = $InventorySlotsContainer
onready var parent = get_owner()

var SAVE_KEY = "inventory"

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	update_inventory_display()
	update_inventory_display()
	inventory.make_items_unique()

func update_inventory_slot_display(item_index):
	if item_index <= (inventory.items.size() - 4) and item_index != -1: 
		var inventorySlotDisplay = gridContainer.get_child(item_index)
		var item = inventory.items[item_index]
		inventorySlotDisplay.display_item(item)

func update_inventory_display():
	for item_index in inventory.items.size() - 3:
		update_inventory_slot_display(item_index)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)

func _unhandled_input(event):
	if event.is_action_released("ui_left"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index, inventory.drag_data.item)

func save(save_game : Resource):
	var inv = []
	for i in inventory.items.size():
		var obj = {}
		if inventory.items[i] is Item:
			obj.amount = inventory.items[i].amount
			obj.name = inventory.items[i].name
		inv.append(obj)
	save_game.data[SAVE_KEY] = inv

func load(save_game : Resource):
	for i in save_game.data[SAVE_KEY].size():
		var obj = save_game.data[SAVE_KEY][i]
		if !obj.has("name") || !obj.has("amount"):
			inventory.items[i] = null
		else:
			var item = load("res://Items/Resources/" + obj.name + ".tres")
			item.amount = obj.amount
			inventory.items[i] = item
			inventory.emit_signal("items_changed", [i])
	Global.emit_signal("itembar_changed")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
