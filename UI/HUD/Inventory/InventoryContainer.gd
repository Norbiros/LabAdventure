extends Control

func _ready():
	get_child(1).get_child(0).get_child(1).hide()
	get_child(0).hide()

func _unhandled_key_input(event) -> void:
	if Input.is_action_just_pressed("inventory_toggle"):
		Global.inventory_state = !Global.inventory_state

	var obj = get_child(1).get_child(0).get_child(1)
	var obj2 = get_child(0)
	obj.show() if Global.inventory_state else obj.hide()
	obj2.show() if Global.inventory_state else obj2.hide()
