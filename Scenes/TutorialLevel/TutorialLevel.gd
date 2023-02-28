extends Node2D

func _ready():
	var gui = load("res://UI/HUD/GUI/GUI.tscn").instance()
	add_child(gui)
	GameSaver.load_level()

