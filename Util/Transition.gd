extends ColorRect

onready var animationPlayer = $AnimationPlayer

func fade_in():
	animationPlayer.play("FadeIn")
