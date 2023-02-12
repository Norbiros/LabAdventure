extends Node2D

func _ready():
	GameSaver.load_level()
	var gui = load("res://UI/HUD/GUI/GUI.tscn").instance()
	add_child(gui)
