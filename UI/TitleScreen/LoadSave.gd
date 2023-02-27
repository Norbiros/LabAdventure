extends Control

onready var saves = get_node("../../")
onready var delete_confirm = get_node("../../../DeleteConfirm")

func _ready():
	var name = GameSaver.load_preview(get_index())
	if name == "":
		$PlayGame.text = "Stwórz"
	else:
		$PlayGame.text = name
		
func _on_PlayGame_button_down():
	Global.emit_signal("start_creating_game", get_index(), $PlayGame.text == "Stwórz")

func _on_Button_button_down():
	Global.deleting_save_id = get_index()
	saves.hide()
	delete_confirm.show()
