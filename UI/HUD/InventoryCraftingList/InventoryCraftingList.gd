extends Control

var state = true
onready var texture = $TextureRect
onready var button = $BookButton
onready var scroll = $HBoxContainer
onready var scrollbar = $HBoxContainer/ScrollContainer
onready var scrollbar2 = $HBoxContainer/ScrollContainer2
onready var vbox = $HBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
onready var slots = get_parent().get_node("InventorySlotsContainer")
onready var display = get_parent().get_node("InventoryInteractionDisplay")

onready var descriptionName = $HBoxContainer/ScrollContainer2/MarginContainer/VBoxContainer/Label
onready var descriptionDescription = $HBoxContainer/ScrollContainer2/MarginContainer/VBoxContainer/Description
onready var descriptionCreation = $HBoxContainer/ScrollContainer2/MarginContainer/VBoxContainer/Creation

signal crafting_changed(crafting)



func _ready():
	Global.connect("inventory_state_change", self, "_inventory_state_changed")
	self.connect("crafting_changed", self, "_crafting_changed")
	scrollbar.get_v_scrollbar().rect_scale.x = 0
	scrollbar2.get_v_scrollbar().rect_scale.x = 0
	texture.hide()
	scroll.hide()
	var first_crafting = null
	for crafting_name in InventoryCraftings.craftings.keys():
		var resource = preload("res://UI/HUD/InventoryInteraction/InventoryCraftingElement.tscn")
		var obj = resource.instance()
		var crafting = InventoryCraftings.craftings[crafting_name]
		obj.description = crafting["description"]
		obj.set_name(crafting["name"])
		obj.set_crafting(crafting["ingredients"], crafting["result"])
		vbox.add_child(obj)
		if first_crafting == null:
			first_crafting = obj
	
	_crafting_changed(first_crafting)

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
		if Global.is_near_crafting:
			display.show()
	else:
		texture.show()
		scroll.show()
		slots.hide()
		display.hide()

func _crafting_changed(crafting):
	descriptionName.text = crafting.crafting_name
	descriptionDescription.text = crafting.description
	var values = "Substraty:\n"
	for v in crafting.ingredients:
		var resource = load("res://Items/Resources/" + v + ".tres")
		values += resource.displayName + " " + str(crafting.ingredients[v]) + "\n"
	values += "Produkty:\n"
	for v in crafting.result:
		var resource = load(v)
		values += resource.displayName + " " + str(crafting.result[v]) + "\n"
	descriptionCreation.text = values

