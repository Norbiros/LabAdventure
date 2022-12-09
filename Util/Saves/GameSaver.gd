# Saves and loads savegame files
# Each node is responsible for finding itself in the save_game
# dict so saves don't rely on the nodes' path or their source file

# W tym momencie używam systemu działającego na resources
# I to działa ogólnie spoko, ale w ekwipunku muszę to konwertować na json
# Dlatego mam 2 rowiązania:
# - poszukać systemu zapisywania na json (od GDquest)
# - założyć że to 1 wyjątek i zostawić
#
# HMM

extends Node

const SaveGame = preload('res://Util/Saves/SaveGame.gd')
# TODO: Use project setting to save to res://debug vs user://
var SAVE_FOLDER: String = "user://"#"res://debug/save"
var SAVE_NAME_TEMPLATE: String = "save_%03d.tres"

var saveGameResource: Resource
var gameID: int
var level: int

var level_name: String = ""


func load_level():
	self.load(level)


func save():
	if level_name == "": return
	save_level(gameID)

func save_level(id: int):
	# Passes a SaveGame resource to all nodes to save data from
	# and writes it to the disk
	var save_game := SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group('save'):
		node.save(save_game)
	
	save_game.data["LEVEL_name"] = level_name

	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)

	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var error: int = ResourceSaver.save(save_path, save_game)
	saveGameResource = save_game
	
	if error != OK:
		print('There was an issue writing the save %s to %s' % [id, save_path])

func save_preview(id: int, name: String):
	var save_game := SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")

	var directory: Directory = Directory.new()
	if not directory.dir_exists(SAVE_FOLDER):
		directory.make_dir_recursive(SAVE_FOLDER)
	
	save_game.data["LEVEL_name"] = name

	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var error: int = ResourceSaver.save(save_path, save_game)
	saveGameResource = save_game
	
	if error != OK:
		print('There was an issue writing the save %s to %s' % [id, save_path])


func load_preview(id: int):
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file: File = File.new()
	if not file.file_exists(save_file_path):
		return ""

	var save_game: Resource = load(save_file_path)
	
	if save_game.data.has("LEVEL_name"):
		level_name = save_game.data["LEVEL_name"]
		return save_game.data["LEVEL_name"]
	else:
		return ""

func load(id: int):
	# Reads a saved game from the disk and delegates loading
	# to the individual nodes to load
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
	var file: File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return

	var save_game: Resource = load(save_file_path)
	for node in get_tree().get_nodes_in_group('save'):
		if node.SAVE_KEY != null && save_game.data.has(node.SAVE_KEY):
			node.load(save_game)
	
	saveGameResource = save_game
	gameID = id
	level_name = save_game.data["LEVEL_name"]
	if save_game.data.has(Global.SAVE_KEY):
		Global.load(save_game)
