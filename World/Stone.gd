extends Area2D

var interacted = false

var items = ["P.tres", "Sulfur.tres", "IronOre.tres"]

func _on_Stone_body_entered(body):
	if body.name  == "Player" and interacted == false:
		Global.player_interactions[self.name] = ["Kliknij, F aby podnieść!", self, "run_interaction"]

func run_interaction():
	interacted = true
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	print(items)
	print(items.size() - 1)
	print(rng.randi_range(0, items.size() - 1))
	var item = items[rng.randi_range(0, items.size() - 1)]
	print(item)
	
	var car_resource = preload("res://Util/ItemDrop.tscn")
	var car = car_resource.instance()
	car.resource = "res://Items/Resources/"+item
	car.position = position
	car.z_index = 10
	get_owner().call_deferred("add_child", car)
	queue_free()


func _on_Stone_body_exited(body):
	if body.name  == "Player":
		Global.player_interactions.erase(self.name)
		
		
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
