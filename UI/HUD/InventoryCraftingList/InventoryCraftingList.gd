extends Control

var state = true
onready var texture = $TextureRect
onready var button = $BookButton
onready var scroll = $HBoxContainer
onready var scrollbar = $HBoxContainer/ScrollContainer
onready var vbox = $HBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
onready var slots = get_parent().get_node("InventorySlotsContainer")
onready var display = get_parent().get_node("InventoryInteractionDisplay")

func _ready():
	Global.connect("inventory_state_change", self, "_inventory_state_changed")
	scrollbar.get_v_scrollbar().rect_scale.x = 0
	texture.hide()
	scroll.hide()
	for crafting_name in InventoryCraftings.craftings.keys():
		print(InventoryCraftings.craftings[crafting_name]["name"])
		var resource = preload("res://UI/HUD/InventoryInteraction/InventoryCraftingElement.tscn")
		var obj = resource.instance()
		obj.get_node("Name").text = "xd"
		vbox.add_child(obj)
		for v in range(10):
			obj = resource.instance()
			obj.get_node("Name").text = str(v)
			vbox.add_child(obj)
			print(v)
		obj = resource.instance()
		obj.get_node("Name").text = "str(v)"
		vbox.add_child(obj)


func _inventory_state_changed(inventory_state):
	if inventory_state:
		texture.hide()
		button.hide()
		scroll.hide()
	else:
		state = true
		button.show()
		
func _on_BookButton_pressed():
	state = !state
	change_state()
	

func change_state():
	if state:
		texture.hide()
		scroll.hide()
		slots.show()
		display.show()
	else:
		texture.show()
		scroll.show()
		slots.hide()
		display.hide()
