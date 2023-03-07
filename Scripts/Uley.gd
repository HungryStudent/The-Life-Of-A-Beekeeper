extends Area2D


signal with_magazin
signal button_sound
signal change_ostatok

func _ready():
	$Panel/time_full_fill.wait_time = $"/root/Parameters".stuff["full_fill_time"]

	
func _on_Timer_timeout():
	$Panel/Sborbar.value +=1

func play_button():
	if $"/root/Parameters".stuff["sounds_bool"]:
		$"/root/Parameters/button_sound".play()

func _on_Button_pressed():
	if $Panel/Full_med.value == 100:
		$Panel/Timer.start()
	play_button()


func _on_time_full_fill_timeout():
	$Panel/Full_med.value+=1


func _on_Sborbar_value_changed(value):
	if $Panel/Sborbar.value == 100:
		$"/root/Parameters".stuff["number_anim_type"] = 2
		$Panel/Timer.stop()
		$Panel/Full_med.value = 0
		$Panel/Sborbar.value = 0


func _on_BeeKepeer_fix_ui():
	$Panel.visible = false


func _on_Uley_body_entered(body):
	$Panel.visible = true


func _on_Uley_body_exited(body):
	$Panel.visible = false
	$Panel/Timer.stop()
	$Panel/Sborbar.value = 0
