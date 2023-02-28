extends Control


var dialogues = {}
var current_dialogue = []
var dialogue_index = 0
var dialogue_name = ""
onready var SAVE_KEY = "dialogue_" + name

onready var textEl = $CenterContainer/VBoxContainer/Text
onready var nameEl = $CenterContainer/VBoxContainer/Name
onready var infoEl = $CenterContainer/VBoxContainer/Info

func _ready():
	dialogues = get_json()
	Global.connect("show_dialogue", self, "_show_dialogue")
	_show_dialogue_message()

func _show_dialogue(dialogue: String) -> void:
	current_dialogue = dialogues[dialogue]["dialogue"]
	dialogue_name = dialogue
	dialogue_index = 0
	_show_dialogue_message()

func _show_dialogue_message() -> void:
	infoEl.hide()
	if current_dialogue.size() == 0:
		nameEl.text = ""
		textEl.text = ""
	else:
		nameEl.text = current_dialogue[dialogue_index]["name"]
		textEl.text = current_dialogue[dialogue_index]["text"]
		if "Ah! Co tu się stało!" in current_dialogue[dialogue_index]["text"]:
			infoEl.show()

func _unhandled_key_input(_event) -> void:
	var state = Global.inventory_state
	if Input.is_action_just_pressed("next_dialogue"):
		if dialogue_index + 2 > len(current_dialogue) and current_dialogue != []:
			var next_dialogue = dialogues[dialogue_name]["next_dialogue"]
			Global.emit_signal("dialogue_ended", dialogue_name, next_dialogue)
			current_dialogue = []
			dialogue_index = -1
			dialogue_name = ""
		dialogue_index += 1
		_show_dialogue_message()
		

func get_json() -> Dictionary:
	var path = "res://Configuration/dialogues.json"
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		printerr("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		printerr("\tError: ", result_json.error)
		printerr("\tError Line: ", result_json.error_line)
		printerr("\tError String: ", result_json.error_string)
		return {}
	var obj = result_json.result
	return obj

func save(save_game: Resource):
	save_game.data[SAVE_KEY] = [current_dialogue, dialogue_index, dialogue_name]
	

func load(save_game: Resource):
	var save_val = save_game.data[SAVE_KEY]
	current_dialogue = save_val[0]
	dialogue_index = save_val[1]
	dialogue_name = save_val[2] 
	_show_dialogue_message()
