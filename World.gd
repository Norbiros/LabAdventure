extends Node2D

func _ready():
	var gui = load("res://UI/HUD/GUI/GUI.tscn").instance()
	add_child(gui)
	GameSaver.load_level()
	if Global.load_fabule:
		Global.emit_signal("show_dialogue", "Init")
