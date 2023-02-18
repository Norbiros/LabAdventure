extends Control

onready var inventorySlots = get_node("CanvasLayer/CenterContainer/InventoryDisplay/InventorySlotsContainer")
onready var textureRect = get_node("CanvasLayer/CenterContainer/InventoryDisplay/TextureRect")
onready var inventoryName = get_node("CanvasLayer/CenterContainer/InventoryDisplay/TextureRect/InventoryName")
onready var inventoryInteractionDisplay = get_node("CanvasLayer/CenterContainer/InventoryDisplay/InventoryInteractionDisplay")
onready var inventoryInteraction = get_node("CanvasLayer/CenterContainer/InventoryDisplay/InventoryInteractionDisplay")

func _ready():
	inventorySlots.hide()
	textureRect.hide()
	inventoryInteraction.hide()
	show()

func _unhandled_key_input(_event) -> void:
	var state = Global.inventory_state
	if Input.is_action_just_pressed("inventory_toggle"):
		Global.inventory_state = !Global.inventory_state
	if Input.is_action_just_pressed("inventory_close"):
		Global.inventory_state = false
	if state == Global.inventory_state: return
	
	Global.emit_signal("inventory_state_change", state)
	if Global.inventory_state:
		inventorySlots.show()
		textureRect.show()
		inventoryInteraction.show()
		
		if Global.is_near_crafting:
			inventoryInteractionDisplay.show()
			inventoryName.rect_position = Vector2(105, 20)
		else:
			inventoryInteractionDisplay.hide()
			inventoryName.rect_position = Vector2(105, 35)
	else: 
		inventorySlots.hide()
		textureRect.hide()
		inventoryInteraction.hide()
		Global.emit_signal("inventory_closed")
