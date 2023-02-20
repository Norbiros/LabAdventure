extends Control

onready var saves = get_node("../../")#$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/SelectSave
onready var delete_confirm = get_node("../../../DeleteConfirm")#$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/DeleteConfirm

func _ready():
	var name = GameSaver.load_preview(get_index())
	if name == "":
		$PlayGame.text = "Stwórz"
	else:
		$PlayGame.text = name
		
func _on_PlayGame_button_down():
	Global.emit_signal("start_creating_game", get_index())

func _on_Button_button_down():
	Global.deleting_save_id = get_index()
	saves.hide()
	delete_confirm.show()
	#GameSaver.delete_level(get_index())
	#$PlayGame.text = "Stwórz"
