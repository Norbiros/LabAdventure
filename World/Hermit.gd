extends KinematicBody2D

var dialogue_index = "HermitDialogue1"
var interacted = false
var player_in_area2d = false
var SAVE_KEY = name + "-dialogue-index"

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")

func _ready():
	Global.connect("dialogue_ended", self, "_dialogue_ended")
	
func _dialogue_ended(dialogue: String, next_dialogue):
	if !("Hermit" in next_dialogue):
		return
	dialogue_index = next_dialogue
	interacted = false
	if states() and player_in_area2d:
		Global.player_interactions[self.name] = ["Kliknij F, aby porozmawiać z Hermitem!", self, "run_interaction"]

func run_interaction():
	if !states():
		return
	interacted = true
	Global.player_interactions.erase(self.name)

func states():
	# Tutaj można dodawać różne interaktywne zadania, po prostu od ifów.
	print(Global.prev )
	if dialogue_index == "FirstHermitChoise":
		if inventory.amount_of_items("H2SO4Tube") >= 5:
			Global.emit_signal("show_dialogue", "HermitDialogueHaveItems")
		else:
			Global.emit_signal("show_dialogue", "HermitDialogueDontHaveItems")
	elif dialogue_index == "END":
		return false
	else:
		Global.emit_signal("show_dialogue", dialogue_index)
	return true


func _on_Area2D_body_entered(body):
	if body.name  == "Player":
		Global.player_interactions[self.name] = ["Kliknij F, aby porozmawiać z Hermitem!", self, "run_interaction"]
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
