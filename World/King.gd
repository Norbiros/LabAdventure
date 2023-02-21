extends KinematicBody2D

var interacted = false

func run_interaction():
	if interacted == true: return
	interacted = true
	Global.emit_signal("show_dialogue", "KingDialogue1")
	Global.player_interactions.erase(self.name)
	

func _on_Area2D_body_entered(body):
	if body.name  == "Player" and interacted == false:
		Global.player_interactions[self.name] = ["Kliknij, aby porozmawiać z królem!", self, "run_interaction"]


func _on_Area2D_body_exited(body):
	if body.name  == "Player":
		Global.player_interactions.erase(self.name)
