extends Control

var crafting_name = ""
var description = ""
var path = ""
var ingredients = []
var result = []

func set_name(name_text):
	$Name.text = name_text
	crafting_name = name_text

func set_crafting(ingredients_i, result_i):
	ingredients = ingredients_i
	result = result_i


func _on_Name_pressed():
	get_parent().get_parent().get_parent().get_parent().get_parent().emit_signal("crafting_changed", self)
