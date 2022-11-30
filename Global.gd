extends Node

signal teleported_in(next_scene_path)
signal itembar_changed()

var start_position = Vector2.ZERO
var teleporting = false
var show_tp_animation = false

var inventory_state = false
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres") # So it is saved when you change scene

func _ready():
	emit_signal("itembar_changed")
	emit_signal("teleported_in") # Remove stupid debugger warning
