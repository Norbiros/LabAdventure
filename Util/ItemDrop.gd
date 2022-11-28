tool
class_name ItemDrop
extends Area2D

export(String, FILE) var resource = ""

onready var textureRect = get_node("Sprite/TextureRect")
onready var animationPlayer = $AnimationPlayer

var player = null
var speed = 0.9
onready var resourceObj = load(resource)

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var motion = Vector2(0, 0)

func _ready():
	textureRect.texture = resourceObj.texture
	animationPlayer.play("Idle")
	

func _get_configuration_warning():
	if resource == "":
		return "next_scene_path is null"
	else:
		return ""
		
func _on_ItemDrop_body_entered(body):
	if body.name == "Player":
		if resource == "": return
		animationPlayer.stop()
		player = body

func _physics_process(delta):
	if player != null:
		motion = position.direction_to(player.position) * delta * 10 * speed
		position.x += motion.x
		position.y += motion.y
		speed += 0.1
		motion = Vector2(0, 0)
		if position.distance_to(player.position) <= 1.5:
			inventory.add_item( resourceObj )
			queue_free()
