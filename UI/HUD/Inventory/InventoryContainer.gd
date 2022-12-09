extends Control

onready var obj = get_node("InventoryDisplay/InventorySlotsContainer")
onready var obj2 = get_node("InventoryDisplay/TextureRect")

func _ready():
	obj.hide()
	obj2.hide()
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _unhandled_key_input(_event) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		Global.inventory_state = !Global.inventory_state
	if Input.is_action_just_pressed("inventory_close"):
		Global.inventory_state = false
	
	if Global.inventory_state:
		obj.show()
		obj2.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else: 
		obj.hide()
		obj2.hide()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
