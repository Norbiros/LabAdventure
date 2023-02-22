extends Node

signal teleported_in(next_scene_path)
signal itembar_changed()
signal start_creating_game(level)
signal remove_save(level)
signal start_game(level)
signal pressed_menu_button(button)
signal inventory_closed()
signal inventory_state_change(state)
signal show_dialogue(dialogue)
signal dialogue_ended()

var start_position = Vector2.ZERO
var teleporting = false
var show_tp_animation = false
var SAVE_KEY = "global"
var player_interactions = {}
var is_near_crafting = false
var deleting_save_id = -1

var level_name = "Untitled"

var inventory_state = false
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres") # So it is saved when you change scene

func _ready():
	emit_signal("itembar_changed")
	emit_signal("teleported_in") # Remove stupid debugger warning
	OS.min_window_size = Vector2(1280, 720)


func save(save_game : Resource):
	save_game.data[SAVE_KEY + "_level_name"] = level_name

func load(save_game : Resource):
	start_position = save_game.data[SAVE_KEY]

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if get_tree().get_current_scene().get_name() != "TitleScreen":
			emit_signal("inventory_closed")
			GameSaver.save()

func _unhandled_key_input(_event) -> void:
	if Input.is_action_just_pressed("open_main_scene"):
		GameSaver.save()
		get_tree().change_scene_to(load("res://UI/TitleScreen/TitleScreen.tscn"))
