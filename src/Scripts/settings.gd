extends Control

@onready var music_s: HSlider = $TileScaleContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/MusicS
@onready var sfxs: HSlider = $TileScaleContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/SFXS
@onready var ui: HSlider = $TileScaleContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/UI


func _ready() -> void:
	SaveManager.load_config()
	music_s.value = AudioServer.get_bus_volume_linear(2) 
	sfxs.value = AudioServer.get_bus_volume_linear(3) 
	ui.value = AudioServer.get_bus_volume_linear(4) 
	
	#music_s.value_changed.connect(_on_music_s_value_changed)
	#sfxs.value_changed.connect(_on_sfxs_value_changed)
	#ui.value_changed.connect(_on_ui_value_changed)
	
	

func _on_music_s_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)
	Audio.ui_focus_change()
	SaveManager.save_config()


func _on_sfxs_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(3, value)
	Audio.ui_focus_change()
	SaveManager.save_config()


func _on_ui_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(4, value)
	Audio.ui_focus_change()
	SaveManager.save_config()
