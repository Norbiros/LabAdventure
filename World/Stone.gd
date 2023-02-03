extends Area2D

var interacted = false

func _on_Stone_body_entered(body):
	if body.name  == "Player" and interacted == false:
		Global.player_interactions[self.name] = ["Kliknij, aby podnieść!", self, "run_interaction"]

func run_interaction():
	interacted = true
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	var car_resource = preload("res://Util/ItemDrop.tscn")
	var car = car_resource.instance()
	car.resource = "res://Items/Resources/IronOre.tres"
	car.position = position
	car.z_index = 10
	get_owner().call_deferred("add_child", car)
	queue_free()


func _on_Stone_body_exited(body):
	if body.name  == "Player":
		Global.player_interactions.erase(self.name)
