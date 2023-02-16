extends Control

onready var craftArrow = get_node("CraftArrowFull")
signal show_crafting_recepies(item)
signal crafted(item)
signal start_crafting(item, time)

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var time_left = -1.0
var start_time = -1.0
const TIMER_SPEED = 0.25
var timer = Timer.new()
var item_to_craft = null

func _ready():
	connect("start_crafting", self, "_start_crafting")
	timer.connect("timeout",self,"timer_tick")
	timer.wait_time = TIMER_SPEED
	timer.one_shot = false
	add_child(timer)
	timer.start()

func _start_crafting(item, time):
	time_left = time
	start_time = time
	item_to_craft = item

func timer_tick():
	if time_left < 0:
		craftArrow.material.set_shader_param("crop_right",0.75)
		return
	if time_left == 0:
		time_left -= TIMER_SPEED
		emit_signal("crafted", item_to_craft)
		return
	var value = ((time_left / start_time) * 0.5) + 0.25
	craftArrow.material.set_shader_param("crop_right",value)
	time_left -= TIMER_SPEED

func can_drop_data(_position, data):
	return true

func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
