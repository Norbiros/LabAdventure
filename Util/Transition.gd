extends ColorRect

onready var animationPlayer = $AnimationPlayer

func _ready():
	if Global.connect("teleported_in", self, "_animation") != 0: 
		print("Strange error!")
		
	if Global.show_tp_animation:
		animationPlayer.play("FadeOut")
	else:
		animationPlayer.play("Clear")
	yield( animationPlayer, "animation_finished" )
	Global.teleporting = false

func _animation(next_scene_path):
	Global.teleporting = true
	Global.inventory_state = false
	animationPlayer.play("FadeIn")
	yield( animationPlayer, "animation_finished" )
	if get_tree().change_scene(next_scene_path) != OK:
		printerr("Unexpected change scene error!")
