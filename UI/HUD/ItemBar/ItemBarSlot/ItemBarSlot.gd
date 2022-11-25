extends Control
class_name ItemBarSlot

const SELECTED_TEXTURE: Texture = preload("res://UI/HUD/ItemBar/HeartUIFull.png")
const UNSELECTED_TEXTURE: Texture = preload("res://UI/HUD/ItemBar/HeartUIEmpty.png")

onready var background_texture_rect = $BackgroundTexture
onready var item_display = $ItemDisplay

var selected: bool = false
var current_item: Item

func set_selected(select: bool) -> void:
	selected = select
	background_texture_rect.texture = SELECTED_TEXTURE if selected else UNSELECTED_TEXTURE

func show_item(item: Item) -> void:
	current_item = item
	item_display.texture = item.texture
