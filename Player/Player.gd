extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500
const MAX_SIZE = 995;
const MIN_SIZE = -990;
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var SAVE_KEY: String  = "player_" + name

func _ready():
	get_owner().get_node("Camera").position = Global.start_position
	get_owner().get_node("Camera").reset_smoothing()
	self.global_position = Global.start_position
	
func _physics_process(delta):
	var pos = get_position();
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector = input_vector.normalized()
	if Global.inventory_state or Global.teleporting: input_vector = Vector2.ZERO
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	set_position(Vector2(clamp(pos.x, MIN_SIZE, MAX_SIZE), clamp(pos.y, MIN_SIZE, MAX_SIZE)))
	velocity = move_and_slide(velocity)

func save(save_game : Resource):
	save_game.data[SAVE_KEY] = position
	save_game.data[Global.SAVE_KEY] = position

func load(save_game : Resource):
	print("asd")
	position = save_game.data[SAVE_KEY]
	get_owner().get_node("Camera").position = position
	get_owner().get_node("Camera").reset_smoothing()
