extends Control


onready var settings = get_node("/root/Settings")


func _on_HomeBtn_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/HomeScreen.tscn")


func _on_RetryBtn_pressed():
	get_tree().reload_current_scene()
	hide()
	get_tree().paused = false


func _on_Player_gameOver(score):
	get_tree().paused = true
	for section in settings.settings.keys():
		if section == "highscores":
			for key in settings.settings[section].keys():
				if key == "highscore":
					if score > settings.settings[section][key]:
						settings.settings[section][key] = score
	settings.saveSettings()
	
	get_node("GameOverSound").play()
		
	show()
	
