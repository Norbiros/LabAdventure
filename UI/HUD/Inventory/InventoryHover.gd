extends Control

onready var label = $Label
onready var description = $Description
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")


func _process(_delta):
	if Global.inventory_state == true and inventory.mouse_hovered_item != null:
		show()
		if inventory.mouse_hovered_item != null:
			label.text = inventory.mouse_hovered_item.displayName
			description.text = inventory.mouse_hovered_item.description
		var pos = get_global_mouse_position()
		pos.x += 10
		rect_position = pos
	else:
		hide()
