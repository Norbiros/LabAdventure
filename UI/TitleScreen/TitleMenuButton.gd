extends Control


export(String) var button_name = ""
export(bool) var flip = false
onready var menuButton = $TitleMenuButton/Label

func _ready():
	menuButton.text = button_name
	$TitleMenuButton.flip_h = flip

func _on_TitleMenuButton_button_down():
	Global.emit_signal("pressed_menu_button", button_name)
