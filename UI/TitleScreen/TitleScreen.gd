extends Control

onready var saves = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SelectSave
onready var main = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/MainButtons
signal type_name()

func _ready():
	Global.connect("start_game", self, "_start_game")
	Global.connect("pressed_menu_button", self, "_pressed_menu_button")

func _start_game(level, new):
	if new:
		get_tree().change_scene("res://Scenes/TutorialLevel/TutorialLevel.tscn")
	else:
		get_tree().change_scene("res://World.tscn")
	GameSaver.level = level

func _pressed_menu_button(button):
	if button == "Graj":
		main.hide()
		saves.show()
	if button == "Zamknij":
		get_tree().quit()
