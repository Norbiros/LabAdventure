extends Control

onready var interactionText1 = $InteractionText1


func _process(delta):
	var interactions = Global.player_interactions
	if len(interactions) >= 1:
		_set_visible(interactionText1, true, interactions[interactions.keys()[0]][0])
	else:
		_set_visible(interactionText1, false, "")


func _unhandled_input(event):
	if event.is_action_released("interaction_key"):
		var interactions = Global.player_interactions
		var interaction_key = interactions.keys()[0]
		if len(interactions) == 0: return
		if interactions[interaction_key][1] == null: return
		interactions[interaction_key][1].callv(interactions[interaction_key][2], [])
		interactions.remove(0)

func _set_visible(interaction_element, show, text):
	if show == true:
		interaction_element.show()
		interaction_element.text = text
	else:
		interaction_element.hide()
