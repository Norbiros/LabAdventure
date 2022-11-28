extends Node

signal teleported_in(next_scene_path)
signal itembar_changed()

var start_position = Vector2.ZERO
var inventory_state = false

var teleporting = false
var show_tp_animation = false
var debug: bool = false

func _ready():
	emit_signal("itembar_changed")
	emit_signal("teleported_in") # Remove stupid debugger warning
