extends Control

onready var craftArrow = get_node("CraftArrowFull")
signal start_crafting(item, second_item)
signal crafted(item, second_item, item_ratio)

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var time_left = -1.0
var start_time = -1.0
var item_ratio = 0
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
	item_ratio = crafted["ratio"]
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
		emit_signal("crafted", item_to_craft, second_item_to_craft, item_ratio)
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

	if item is Item:
		items[item.name] = item
	if second_item is Item:
		items[second_item.name] = second_item
	
	for crafting_name in InventoryCraftings.craftings.keys():
		return_items = []
		time = -1.0
		var crafting = InventoryCraftings.craftings[crafting_name]
		var can_craft = true
		var amounts = []
		var ingredient_amounts = []
		for ingredient in crafting.ingredients.keys():
			var ingredient_amount = crafting["ingredients"][ingredient]
			if !items.keys().has(ingredient):
				can_craft = false
			else:
				amounts.append(items[ingredient].amount / ingredient_amount)
				ingredient_amounts.append(ingredient_amount)
		
		var amount_ratio = 0
		if len(amounts) == 2:
			amount_ratio = min(amounts[0], amounts[1])
		elif len(amounts) == 1:
			amount_ratio = amounts[0]
			
		if can_craft and amount_ratio != 0:
			for result in crafting.result:
				var i = load(result)
				i.amount = amount_ratio * crafting["result"][result]
				time = crafting["time"]
				return_items.append(i)
			
			var amounts_ratio = []
			for ingredient in ingredient_amounts:
				amounts_ratio.append(ingredient * amount_ratio)

			return {"time": time, "return_items": return_items, "ratio": amounts_ratio}
	return {"time": -1, "return_items": [], "ratio": [0, 0]}
