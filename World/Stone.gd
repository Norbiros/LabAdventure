extends Area2D



func _on_Stone_body_entered(body):
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
