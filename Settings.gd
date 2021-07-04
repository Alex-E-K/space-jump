extends Node


const SAVE_PATH = "user://settings_saves.cfg"

var settingsFile = ConfigFile.new()
var settings = {
	"highscores": {
		"highscore": int(0),
		"crazyHighscore": int(0)
	}
}


# Called when the node enters the scene tree for the first time.
func _ready():
	loadSettings()


func loadSettings():
	var error = settingsFile.load(SAVE_PATH)
	if error != OK:
		print("Error loading the settings. Error code: %s" % error)
		return null
	
	for section in settings.keys():
		for key in settings[section].keys():
			settings[section][key] = settingsFile.get_value(section, key, null)


func saveSettings():
	for section in settings.keys():
		for key in settings[section].keys():
			settingsFile.set_value(section, key, settings[section][key])
	
	settingsFile.save(SAVE_PATH)

