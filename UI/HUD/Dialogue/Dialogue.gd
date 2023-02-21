extends Control


var dialogues = {}
var current_dialogue = []
var dialogue_index = 0

onready var textEl = $Text
onready var nameEl = $Name

func _ready():
	dialogues = get_json()
	Global.connect("show_dialogue", self, "_show_dialogue")
	_show_dialogue_message()

func _show_dialogue(dialogue):
	current_dialogue = dialogues[dialogue]
	dialogue_index = 0
	_show_dialogue_message()

func _show_dialogue_message():
	if current_dialogue == []:
		nameEl.text = ""
		textEl.text = ""
	else:
		nameEl.text = current_dialogue[dialogue_index]["name"]
		textEl.text = current_dialogue[dialogue_index]["text"]

func _unhandled_key_input(_event) -> void:
	var state = Global.inventory_state
	if Input.is_action_just_pressed("next_dialogue"):
		if dialogue_index + 2 > len(current_dialogue):
			current_dialogue = []
			dialogue_index = -1
		dialogue_index += 1
		_show_dialogue_message()
		

func get_json():
	var path = "res://Configuration/dialogues.json"
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj
