extends Node

const CONFIG_FILE_PATH = "user://settings.cfg"

var save_data : Dictionary
var save = "user://save.sav"
var high_score: float = 0

func _ready() -> void:
	pass


func create_new_save() -> void:
	#add first scene after starting new game
	var new_game_scene: String = ""
	save_data = {
		"scene_path": new_game_scene,
		"high_score": 0,
		}
	var save_file = FileAccess.open(save, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))


func save_game() -> void:
	save_data = {
		"scene_path": SceneManager.cur_scene_uid,
		"high_score": high_score,
	}
	var save_file = FileAccess.open(save, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))


func load_game() -> void:
	if !FileAccess.file_exists(save):
		return
	
	var save_file = FileAccess.open(save, FileAccess.READ)
	save_data = JSON.parse_string(save_file.get_line())
	
	var scene_path: String = save_data.get("scene_path", "uid://cakmndtavkelk")
	SceneManager.transition_main_scene(scene_path)


func save_config() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music", AudioServer.get_bus_volume_linear(2))
	config.set_value("audio", "sfx", AudioServer.get_bus_volume_linear(3))
	config.set_value("audio", "ui", AudioServer.get_bus_volume_linear(4))
	config.save(CONFIG_FILE_PATH)


func load_config() -> void:
	var config := ConfigFile.new()
	var err = config.load(CONFIG_FILE_PATH)
	
	if err != OK:
		AudioServer.set_bus_volume_linear(2, 0.7)
		AudioServer.set_bus_volume_linear(3, 1.0)
		AudioServer.set_bus_volume_linear(4, 1.0)
		return
	
	AudioServer.set_bus_volume_linear(2, config.get_value("audio","music",0.7))
	AudioServer.set_bus_volume_linear(3, config.get_value("audio","sfx",1.0))
	AudioServer.set_bus_volume_linear(4, config.get_value("audio","ui",1.0))
