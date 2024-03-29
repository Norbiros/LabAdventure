extends KinematicBody2D

const ACCELERATION = 800
const MAX_SPEED = 90
const FRICTION = 800
const MAX_SIZE = 995;
const MIN_SIZE = -990;
var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var sprite = $Sprite
onready var shadow = $MediumShadow
onready var shadowWater = $"Shadow-water"
onready var animationState = animationTree.get("parameters/playback")

var SAVE_KEY: String  = "player_" + name

func _ready():
	get_owner().get_node("Camera").position = Global.start_position
	get_owner().get_node("Camera").reset_smoothing()
	self.global_position = Global.start_position

var last_footstep = 0;
func _physics_process(delta):
	var pos = get_position();
	var input_vector = Vector2.ZERO
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left") 
	input_vector = input_vector.normalized()
	var speed = MAX_SPEED
	if get_tree().get_current_scene().get_name() == "World":
		var nearest_name = nearest_titleset()
		if nearest_name:
			speed = 45
			sprite.material.set_shader_param("crop_bottom",0.3)
			shadow.hide()
			shadowWater.show()
		else:
			sprite.material.set_shader_param("crop_bottom",0.0)
			shadow.show()
			shadowWater.hide()
	if Global.inventory_state or Global.teleporting: input_vector = Vector2.ZERO
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		if last_footstep <= 0:
			play_footstep_sound()
			last_footstep = 20
		else:
			last_footstep -= 1
		velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		last_footstep = 0
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	
	set_position(Vector2(clamp(pos.x, MIN_SIZE, MAX_SIZE), clamp(pos.y, MIN_SIZE, MAX_SIZE)))
	velocity = move_and_slide(velocity)

func nearest_titleset():
	var tile_map = get_parent().get_parent().get_node("BetterWaterTilemap")
	if tile_map == null: return false
	var is_in_tileset = false
	var nearest_tile_distance = 17
	var ppos = position
	ppos.y -= 8
	ppos.x -= 8
	
	for pos in tile_map.get_used_cells():
		var tile_position = tile_map.map_to_world(Vector2(pos.x, pos.y))
		var distance = ppos.distance_to(tile_position)
		if distance < nearest_tile_distance:
			var tile_index = tile_map.get_cell(pos.x, pos.y)
			if tile_index != -1:
				var tile_name = tile_map.tile_set.tile_get_name(tile_index)
				if tile_name.left(5) == "deep-":
					nearest_tile_distance = distance
					is_in_tileset = true
	return is_in_tileset
	
func save(save_game : Resource):
	save_game.data[SAVE_KEY] = position
	save_game.data[Global.SAVE_KEY] = position

func load(save_game : Resource):
	position = save_game.data[SAVE_KEY]
	get_owner().get_node("Camera").position = position
	get_owner().get_node("Camera").reset_smoothing()

var rng = RandomNumberGenerator.new()

func play_footstep_sound():
	rng.randomize()
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.7, 1.5)
	$AudioStreamPlayer2D.play(0.0)
