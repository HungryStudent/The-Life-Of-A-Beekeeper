extends Control


func _ready():
	if $"/root/Parameters".over == 1:
		$Main.visible = false
		$over.visible = true
		$"/root/Parameters".over = 0
	if $"/root/Parameters".stuff["music_bool"] == true:
		$Settings/Music.pressed = true
		$AudioStreamPlayer.play()
	else:
		$Settings/Music.pressed = false
	if $"/root/Parameters".stuff["sounds_bool"] == true:
		$Settings/Sounds.pressed = true
	else:
		$Settings/Sounds.pressed = false
	if $"/root/Parameters".stuff["moonwalk_bool"] == true:
		$Settings/Check_moonwalk.pressed = true
	else:
		$Settings/Check_moonwalk.pressed = false
	
	
func play_button():
	if $"/root/Parameters".stuff["sounds_bool"]:
		$"/root/Parameters/button_sound".play()
	
		
func _on_Play_pressed():
	play_button()
	get_tree().change_scene("res://Scenes/main.tscn")


func _on_Quit_pressed():
	play_button()
	get_tree().change_scene("res://Scenes/main_menu.tscn")

	play_button()
	get_tree().quit()


func _on_Settings_pressed():
	play_button()
	$Main.visible = false
	$Settings.visible = true


func _on_Back_pressed():
	var fileSave = File.new()
	var temp = $"/root/Parameters".stuff
	fileSave.open("user://save.json", File.WRITE)
	fileSave.store_string(to_json(temp))
	fileSave.close()
	play_button()
	$Main.visible = true
	$Settings.visible = false


func _on_Check_moonwalk_pressed():
	play_button()
	if $Settings/Check_moonwalk.pressed == true:
		$"/root/Parameters".stuff["moonwalk_bool"] = true
	else:
		$"/root/Parameters".stuff["moonwalk_bool"] = false


func _on_Music_pressed():
	play_button()
	if $Settings/Music.pressed == false:
		$"/root/Parameters".stuff["music_bool"] = false
		$AudioStreamPlayer.stop()
	else:
		$"/root/Parameters".stuff["music_bool"] = true
		$AudioStreamPlayer.play()
		

func _on_Sounds_pressed():
	play_button()
	if $Settings/Sounds.pressed == false:
		$"/root/Parameters".stuff["sounds_bool"] = false
	else:
		$"/root/Parameters".stuff["sounds_bool"] = true


func _on_Help_pressed():
	play_button()
	$Main.visible = false
	$Help.visible = true


func _on_back_pressed():
	play_button()
	$Main.visible = true
	$Help.visible = false


func _on_next_pressed():
	play_button()
	$Main.visible = true
	$over.visible = false

