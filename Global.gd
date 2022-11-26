extends Node

signal teleported_in(next_scene_path)

var start_position = Vector2.ZERO
var inventory_state = false

var teleporting = false
var show_tp_animation = false
