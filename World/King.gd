extends KinematicBody2D

var dialogue_index = "START"
var interacted = false
var player_in_area2d = false
var SAVE_KEY = name + "-dialogue-index"

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")

func _ready():
	Global.connect("dialogue_ended", self, "_dialogue_ended")
	
func _dialogue_ended(dialogue: String):
	if dialogue == "KingDialogueHaveItems":
		dialogue_index = ""
	else:
		dialogue_index = dialogue
	interacted = false
	if player_in_area2d and dialogue_index != "":
		if dialogue == "KingDialogue3":
			Global.player_interactions[self.name] = ["Kliknij, aby dać królowi kwas!", self, "run_interaction"]
		else:
			Global.player_interactions[self.name] = ["Kliknij, aby porozmawiać z królem!", self, "run_interaction"]
	else: 
		Global.player_interactions.erase(self.name)

func run_interaction():
	if dialogue_index == "START" and interacted == false:
		dialogue_index = "KingDialogue1"
		Global.emit_signal("show_dialogue", "KingDialogue1")
		Global.player_interactions.erase(self.name)
		interacted = true
	elif dialogue_index == "KingDialogue1" and interacted == false:
		dialogue_index = "KingDialogue2"
		Global.emit_signal("show_dialogue", "KingDialogue2")
		Global.player_interactions.erase(self.name)
		interacted = true
	elif dialogue_index == "KingDialogue2" and interacted == false:
		dialogue_index = "KingDialogue3"
		Global.emit_signal("show_dialogue", "KingDialogue3")
		Global.player_interactions.erase(self.name)
		interacted = true
	else:
		if inventory.amount_of_items("H2SO4Tube") >= 1:
			dialogue_index = ""
			Global.emit_signal("show_dialogue", "KingDialogueHaveItems")
			Global.player_interactions.erase(self.name)
			interacted = true
		else:
			dialogue_index = "KingDontHaveItems"
			Global.emit_signal("show_dialogue", "KingDialogueDontHaveItems")
			Global.player_interactions.erase(self.name)
			interacted = true
	

func _on_Area2D_body_entered(body):
	if body.name  == "Player" and interacted == false and dialogue_index != "":
		Global.player_interactions[self.name] = ["Kliknij, aby porozmawiać z królem!", self, "run_interaction"]
		player_in_area2d = true


func _on_Area2D_body_exited(body):
	if body.name  == "Player":
		Global.player_interactions.erase(self.name)
		player_in_area2d = false

func save(save_game: Resource):
	save_game.data[SAVE_KEY] = [dialogue_index, interacted]

func load(save_game: Resource):
	dialogue_index = save_game.data[SAVE_KEY][0]
	interacted = save_game.data[SAVE_KEY][1]
