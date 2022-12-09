tool

extends Area2D
 
export(String, FILE) var next_scene_path = ""
export(Vector2) var player_spawn_location = Vector2.ZERO

func _get_configuration_warning():
	if next_scene_path == "":
		return "next_scene_path is null"
	else:
		return ""


func _on_Portal_body_entered(body):
	Global.start_position = player_spawn_location
	
	if body.name == "Player":
		Global.emit_signal("teleported_in", next_scene_path)
		Global.show_tp_animation = true
