extends Control
class_name ItemBarSlot

const SELECTED_TEXTURE: Texture = preload("res://UI/HUD/ItemBar/SelectedInventory.png")
const UNSELECTED_TEXTURE: Texture = preload("res://UI/HUD/ItemBar/UnselectedInventory.png")

onready var background_texture_rect = $BackgroundTexture
onready var item_display = $ItemDisplay
onready var animation_player = $AnimationPlayer
var inventory = preload("res://UI/HUD/Inventory/Inventory.tres")

var selected: bool = false

func set_selected(select: bool) -> void:
	if selected && !select:
		animation_player.play("SmallerSize")
	elif !selected && select:
		animation_player.play("BiggerSize")
	
	selected = select
	background_texture_rect.texture = SELECTED_TEXTURE if selected else UNSELECTED_TEXTURE

func show_item(item: Item) -> void:
	if item is Item:
		item_display.texture = item.texture
	else:
		item_display.texture = null
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	if !data.item.is_tool:
		inventory.set_item(data.item_index, data.item)
		return
	var my_item_index = inventory.items.size() - 3 + get_index()
	inventory.swap_item(my_item_index, data.item_index)
	inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null
	Global.emit_signal("itembar_changed")

func get_drag_data(_position):
	var item_index = inventory.items.size() - 3 + get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = inventory.gen_drag_preview(item)
		
		Global.emit_signal("itembar_changed")
		set_drag_preview(dragPreview)
		return data
