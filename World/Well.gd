extends KinematicBody2D

export(String, FILE) var resource = ""
onready var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
onready var resourceObj = load(resource)

func run_interaction():
	var amount = inventory.amount_of_items("EmptyTube")
	inventory.remove_items_by_name("EmptyTube")
	resourceObj.amount = amount
	
	inventory.add_item( resourceObj )
	

func _on_Area2D_body_entered(body):
	if body.name  == "Player":
		Global.player_interactions[self.name] = ["Kliknij, aby zabrać wodę podnieść!", self, "run_interaction"]


func _on_Area2D_body_exited(body):
	if body.name  == "Player":
		Global.player_interactions.erase(self.name)
