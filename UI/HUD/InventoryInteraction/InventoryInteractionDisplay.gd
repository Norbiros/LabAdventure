extends Control

onready var craftArrow = get_node("CraftArrowFull")
signal start_crafting(item, second_item)
signal crafted(item, second_item)

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var time_left = -1.0
var start_time = -1.0
const TIMER_SPEED = 0.25
var timer = Timer.new()
var item_to_craft = null
var second_item_to_craft = null

func _ready():
	connect("start_crafting", self, "_start_crafting")
	timer.connect("timeout", self, "timer_tick")
	timer.wait_time = TIMER_SPEED
	timer.one_shot = false
	add_child(timer)
	timer.start()

func _start_crafting(item, second_item):
	var crafted = craft_items(item, second_item)
	var crafted_items = crafted["return_items"]
	item_to_craft = crafted_items[0] if len(crafted_items) > 0 else null
	second_item_to_craft =  crafted_items[0] if len(crafted_items) > 1 else null
	time_left = crafted["time"]
	start_time = crafted["time"]

func timer_tick():
	if time_left < 0:
		craftArrow.material.set_shader_param("crop_right",0.75)
		return
	if time_left == 0:
		time_left -= TIMER_SPEED
		emit_signal("crafted", item_to_craft, second_item_to_craft)
		return
	var value = ((time_left / start_time) * 0.5) + 0.25
	craftArrow.material.set_shader_param("crop_right",value)
	time_left -= TIMER_SPEED

func can_drop_data(_position, data):
	return true

func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)

func craft_items(item, second_item):
	var items = {}
	var return_items = []
	var time = -1.0
	print(item.name)
	print(second_item)
	
	if item is Item:
		items[item.name] = item
	if second_item is Item:
		items[second_item.name] = second_item
		
	if items.keys().has("IronOre") and len(items.keys()) == 1:
		var i = load("res://Items/Resources/IronIngot.tres")
		i.amount = floor(item.amount / 2) + 1
		return_items.append(i)
		time = 10.0
	
	return {"time": time, "return_items": return_items}
