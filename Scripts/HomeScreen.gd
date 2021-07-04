extends Control


onready var settings = get_node("/root/Settings")

var highscore = 0
var crazyHighscore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for section in settings.settings.keys():
		if section == "highscores":
			for key in settings.settings[section].keys():
				if key == "highscore":
					highscore = settings.settings[section][key]
				elif key == "crazyHighscore":
					crazyHighscore = settings.settings[section][key]
	
	get_node("Camera2D/VBoxContainer/PlayBtn/VBoxContainer/Highscore").text = str("Highscore: %d" % highscore)
	get_node("Camera2D/VBoxContainer/PlayBtn2/VBoxContainer/Highscore").text = str("Highscore: %d" % crazyHighscore)




func _on_PlayBtn_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")


func _on_PlayBtn2_pressed():
	get_tree().change_scene("res://Scenes/CrazyWorld.tscn")
