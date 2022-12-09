tool
class_name ItemDrop
extends Area2D

export(String, FILE) var resource = ""
export(int) var amount = 1

onready var textureRect = $Sprite/TextureRect
onready var animationPlayer = $AnimationPlayer
onready var itemAmountLabel = $Sprite/TextureRect/ItemAmountLabel

onready var SAVE_KEY = "item_" + name + "_pickedup"

var picked_up = false

var player = null
var speed = 0.9
onready var resourceObj = load(resource)

var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")
var motion = Vector2(0, 0)

func _ready():
	textureRect.texture = resourceObj.texture
	animationPlayer.play("Idle")
	if amount > 1:
		itemAmountLabel.text = str(amount)
	else:
		itemAmountLabel.text = ""

func _get_configuration_warning():
	if resource == "":
		return "next_scene_path is null"
	else:
		return ""
		
func _on_ItemDrop_body_entered(body):
	if body.name == "Player" && picked_up == false:
		if resource == "": return
		animationPlayer.stop()
		player = body

func _physics_process(delta):
	if player != null && picked_up == false:
		motion = position.direction_to(player.position) * delta * 10 * speed
		position.x += motion.x
		position.y += motion.y
		speed += 0.1
		motion = Vector2(0, 0)
		resourceObj.amount = amount
		if position.distance_to(player.position) <= 1.5:
			inventory.add_item( resourceObj )
			picked_up = true
			animationPlayer.stop()
			hide()

func save(save_game : Resource):
	save_game.data[SAVE_KEY] = picked_up

func load(save_game : Resource):
	picked_up = save_game.data[SAVE_KEY]
	if picked_up == true:
		hide()
	else:
		show()
