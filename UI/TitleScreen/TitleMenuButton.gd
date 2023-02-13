extends Control


export(String) var button_name = ""
onready var menuButton = $TitleMenuButton

func _ready():
	menuButton.text = button_name

func _on_TitleMenuButton_button_down():
	Global.emit_signal("pressed_menu_button", button_name)
