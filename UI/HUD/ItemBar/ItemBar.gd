extends Control
class_name ItemBar

onready var slot_container: HBoxContainer = $HBoxContainer
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")

var item_slots = []
var selected_slot_index: int
var moved: int = 0

func _ready() -> void:
	_register_slots()
	_select_slot(1)
	Global.connect("itembar_changed", self, "itembar_changed")

func _unhandled_input(_event) -> void:
	if Input.is_action_just_pressed("item_bar_select_next"):
		moved += 1
	
	if Input.is_action_just_pressed("item_bar_select_previous"):
		moved -= 1
	
	if moved >= 7:
		moved = 0
		_select_next_slot()
	elif moved <= -7:
		_select_previous_slot()
		moved = 0


func _unhandled_key_input(event) -> void:
	var key = event.unicode - 49
	if key >= 0 && key < item_slots.size() && event.pressed == true:
		_select_slot(key)
	#if (ev ent is InputEventKey and event.sca):

func _register_slots() -> void:
	item_slots.clear()
	item_slots.append_array(slot_container.get_children())

func _select_slot(slot_index: int) -> void:
	for index in item_slots.size():
		item_slots[index].set_selected(index == slot_index)
	
	selected_slot_index = slot_index
	
	
func _select_next_slot() -> void:
	if selected_slot_index == item_slots.size() - 1:
		_select_slot(0)
	else:
		_select_slot(selected_slot_index + 1)

func _select_previous_slot() -> void:
	if selected_slot_index ==  0:
		_select_slot(item_slots.size() - 1)
	else:
		_select_slot(selected_slot_index - 1)

func update_inventory_slot_display(item_index):
	var itembarSlotDisplay = slot_container.get_child(item_index)
	var item = inventory.items[item_index + 21]
	itembarSlotDisplay.show_item(item)


func itembar_changed():
	update_inventory_slot_display(0)
	update_inventory_slot_display(1)
	update_inventory_slot_display(2)


func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
