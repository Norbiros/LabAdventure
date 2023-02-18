extends Control

var state = true
onready var texture = $TextureRect
onready var button = $BookButton
onready var scroll = $HBoxContainer
onready var scrollbar = $HBoxContainer/ScrollContainer
onready var vbox = $HBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
onready var slots = get_parent().get_node("InventorySlotsContainer")
onready var display = get_parent().get_node("InventoryInteractionDisplay")

onready var descriptionName = $HBoxContainer/ScrollContainer2/VBoxContainer/Label
onready var descriptionDescription = $HBoxContainer/ScrollContainer2/VBoxContainer/Description

signal crafting_changed(crafting)



func _ready():
	Global.connect("inventory_state_change", self, "_inventory_state_changed")
	self.connect("crafting_changed", self, "_crafting_changed")
	scrollbar.get_v_scrollbar().rect_scale.x = 0
	texture.hide()
	scroll.hide()
	for crafting_name in InventoryCraftings.craftings.keys():
		var resource = preload("res://UI/HUD/InventoryInteraction/InventoryCraftingElement.tscn")
		var obj = resource.instance()
		var crafting = InventoryCraftings.craftings[crafting_name]
		obj.description = crafting["description"]
		obj.set_name(crafting["name"])
		obj.set_crafting(crafting["ingredients"], crafting["result"])
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

func _crafting_changed(crafting):
	print(crafting.crafting_name)
	print(crafting.description)
	descriptionName.text = crafting.crafting_name
	descriptionDescription.text = crafting.description
	var values = "Substraty: \n"
	print(values)
	for v in crafting.ingredients:
		var resource = load("res://Items/Resources/" + v + ".tres")
		values += " - " + resource.displayName + "\n"
	values += "Produkty: \n"
	for v in crafting.result:
		var resource = load(v)
		values += " - " +resource.displayName + "\n"
	print(values)

