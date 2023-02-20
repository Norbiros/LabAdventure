extends CenterContainer

onready var saves = get_node("../SelectSave")


func _on_Tak_pressed():
	GameSaver.delete_level(Global.deleting_save_id)
	self.hide()
	saves.show()
	saves.get_node("SelectSaves").get_child(Global.deleting_save_id).get_node("PlayGame").text = "Stwórz"
	Global.deleting_save_id = -1
	


func _on_Nie_pressed():
	self.hide()
	saves.show()
	Global.deleting_save_id = -1
