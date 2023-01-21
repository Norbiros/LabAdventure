extends Control

signal show_crafting_recepies(item)
signal crafted()

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")

func can_drop_data(_position, data):
	print("uwu")
	return true

func drop_data(_position, data):
	print("deow")
	inventory.set_item(data.item_index, data.item)
