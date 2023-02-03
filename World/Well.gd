extends KinematicBody2D

var interacted = false
export(String, FILE) var resource = ""
onready var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
onready var resourceObj = load(resource)

func run_interaction():
	interacted = true
	resourceObj.amount = 2
	inventory.add_item( resourceObj )
	

func _on_Area2D_body_entered(body):
	if body.name  == "Player" and interacted == false:
		Global.player_interactions[self.name] = ["Kliknij, aby zabrać wodę podnieść!", self, "run_interaction"]


func _on_Area2D_body_exited(body):
	if body.name  == "Player":
		Global.player_interactions.erase(self.name)
