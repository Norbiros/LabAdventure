extends Control

func _ready():
	var name = GameSaver.load_preview(get_index())
	if name == "":
		$PlayGame.text = "Stwórz"
	else:
		$PlayGame.text = name
		
func _on_PlayGame_button_down():
	Global.emit_signal("start_creating_game", get_index())

func _on_Button_button_down():
	GameSaver.delete_level(get_index())
	$PlayGame.text = "Stwórz"
