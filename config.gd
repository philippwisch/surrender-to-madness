# this whole code is very dirty
# config should not retrieve these values for volume etc directly, that's
# what sound slider should do.
# but it works and i cant be bothered right now. will maybe change later

extends Node

var config = ConfigFile.new()

var music_volume: float
var effects_volume: float


# Called when the node enters the scene tree for the first time.
func _ready():
	var err = config.load("user://config.cfg")
	
	if err != OK:
		print("Failed to load user preference file! Using default settings.")
		music_volume = 1
		effects_volume = 1
		return
	else:
		music_volume = config.get_value("Config","Music")
		effects_volume = config.get_value("Config","Effects")
		
func save(key: String, value):
	config.set_value("Config", key, value)
	config.save("user://config.cfg")
