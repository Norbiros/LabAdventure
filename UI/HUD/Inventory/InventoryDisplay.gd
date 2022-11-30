extends Control

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
onready var gridContainer = $InventorySlotsContainer

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	update_inventory_display()
	update_inventory_display()
	inventory.make_items_unique()

func update_inventory_slot_display(item_index):
	if item_index <= (inventory.items.size() - 4): 
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
