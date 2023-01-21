extends Control

onready var inventorySlots = get_node("CanvasLayer/CenterContainer/InventoryDisplay/InventorySlotsContainer")
onready var textureRect = get_node("CanvasLayer/CenterContainer/InventoryDisplay/TextureRect")
onready var inventoryInteraction = get_node("CanvasLayer/CenterContainer/InventoryDisplay/InventoryInteractionDisplay")

func _ready():
	inventorySlots.hide()
	textureRect.hide()
	inventoryInteraction.hide()
	show()

func _unhandled_key_input(_event) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		Global.inventory_state = !Global.inventory_state
	if Input.is_action_just_pressed("inventory_close"):
		Global.inventory_state = false
	
	if Global.inventory_state:
		inventorySlots.show()
		textureRect.show()
		inventoryInteraction.show()
	else: 
		inventorySlots.hide()
		textureRect.hide()
		inventoryInteraction.hide()
