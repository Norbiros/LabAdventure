extends Area2D

func _on_HomeEntrance_body_entered(body):
	body.change_scene("res://World.tscn", Vector2(100, 100))
	
