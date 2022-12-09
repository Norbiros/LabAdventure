extends Control

onready var spin_box: SpinBox = $Column/HBoxContainer/SpinBox


func _on_SaveButton_pressed() -> void:
	GameSaver.save_level(floor(spin_box.value))


func _on_LoadButton_pressed() -> void:
	GameSaver.load(floor(spin_box.value))
