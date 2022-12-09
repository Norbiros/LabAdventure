extends LineEdit

var gameID: int

func _input(event):
	if event.is_action_pressed("ui_accept"):
		hide()
		GameSaver.save_preview(gameID, text)
		Global.emit_signal("start_game", gameID)

func _ready():
	if Global.connect("start_creating_game", self, "_show") != OK:
		printerr("Error while connecting! ItemNameInput.gd")

func _show(id):
	gameID = id
	if GameSaver.load_preview(gameID) == "":
		get_parent().get_parent().show()
		get_parent().get_parent().get_parent().get_node("SelectSave").hide()
	else:
		Global.emit_signal("start_game", gameID)
