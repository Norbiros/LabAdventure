extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		Global.is_near_crafting = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		Global.is_near_crafting = false
