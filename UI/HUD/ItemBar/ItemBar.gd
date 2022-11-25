extends Control
class_name ItemBar

onready var slot_container: HBoxContainer = $HBoxContainer

var item_slots = []
var selected_slot_index: int

func _ready() -> void:
	_register_slots()
	_select_slot(1)

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("item_bar_select_next"):
		_select_next_slot()
	
	if Input.is_action_just_pressed("item_bar_select_previous"):
		_select_previous_slot()


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
	
	item_slots[slot_index].show_item( preload("res://Items/Resources/Axe.tres") )
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
