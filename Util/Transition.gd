extends ColorRect

onready var animationPlayer = $AnimationPlayer

func _ready():
	Global.connect("teleported_in", self, "_animation")
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
	get_tree().change_scene(next_scene_path)
