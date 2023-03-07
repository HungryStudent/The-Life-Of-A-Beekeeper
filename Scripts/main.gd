extends Node2D

var rng = RandomNumberGenerator.new()
var litrs_sell
var sprite_table = load("res://Sprites/Garage/table.png")
var sprite_table0 = load("res://Sprites/Garage/table0.png")
signal with_ramki
signal with_bucket
signal no_with_bucket

func _ready():
	$CanvasLayer/money.text = str($"/root/Parameters".stuff["money"])
	var time = OS.get_unix_time()
	for i in range(1, 16):
		get_node("Apiary/Uley"+str(i)+"/Panel/Full_med").value = $"/root/Parameters".stuff["uley"+str(i)] + int((time-$"/root/Parameters".stuff["time"])/$"/root/Parameters".stuff["full_fill_time"])
	for i in range(1, $"/root/Parameters".stuff["number_of_uley"]+1):
		get_node("Apiary/Uley"+str(i)).visible = true
		get_node("Apiary/Uley"+str(i)+"/StaticBody2D/CollisionShape2D").disabled = false
		get_node("Apiary/Uley"+str(i)+"/Panel/time_full_fill").wait_time = $"/root/Parameters".stuff["full_fill_time"]
	
	$Garage/Count_magazin.text = str($"/root/Parameters".stuff["magazin_count"])+"/"+str($"/root/Parameters".stuff["magazins_capacity"])
	$Garage/Count_buckets.text = str($"/root/Parameters".stuff["buckets_count"])+"/"+str($"/root/Parameters".stuff["buckets_capacity"])
	$Market/Count_litrs.text = str($"/root/Parameters".stuff["litrs_count"])+"/"+str($"/root/Parameters".stuff["litrs_capacity"])
	if $"/root/Parameters".stuff["music_bool"]:
		$fon.play()
	if $"/root/Parameters".stuff["sounds_bool"]:
		$Apiary/BeeSounds.play()
		$fontan.play()
		$House/cat/cat.play()
		$gorod.play()
		$rynok.play()

func _input(event):
	if Input.is_action_pressed("open_cheat"):
		$"/root/Parameters".stuff["money"]+=1000
		$CanvasLayer/money.text = str($"/root/Parameters".stuff["money"])
		
func play_button():
	if $"/root/Parameters".stuff["sounds_bool"]:
		$"/root/Parameters/button_sound".play()


func compare_shop(shop, name):
	if $"/root/Parameters".stuff["money"] >= int(get_node("CanvasLayer/"+shop+"/"+name+"/price").text):
		get_node("CanvasLayer/"+shop+"/"+name+"/"+name).disabled = false
	else:
		get_node("CanvasLayer/"+shop+"/"+name+"/"+name).disabled = true


func minus_money(shop, name):
	$"/root/Parameters".stuff["money"] -= int(get_node("CanvasLayer/"+shop+"/"+name+"/price").text)
	$CanvasLayer/money.text = str($"/root/Parameters".stuff["money"])
	

func _on_BeeKepeer_plus_magazin():
	$"/root/Parameters".stuff["magazin_count"] += 1
	$Garage/Count_magazin.text = str($"/root/Parameters".stuff["magazin_count"])+"/"+str($"/root/Parameters".stuff["magazins_capacity"])


func _on_BeeKepeer_fix_ui():
	$Medogonka/Medogonka_panel.visible = false
	$Garage/Buckets_menu.visible = false
	$trashcan/throw_away.visible = false
	$Market/put_litrs.visible = false
	$Market/start_torg.visible = false
	$City/STO/Enter_STO.visible = false
	$City/BeeShop/Enter_BeeShop.visible = false
	$City/Hardware_shop/Enter_HardWareShop.visible = false
	$City/Business_shop/Enter_BusinessShop.visible = false
	

func _on_Timer_timeout():
	$House/bag_fix/CollisionShape2D.position.x = 77.943
	$House/bag_fix/CollisionShape2D.position.y = -88.174


func _on_Table_collision_body_entered(body):
	$table2/Table_panel.visible = true
	$table2/Table_panel/start_print.disabled = false
	if $"/root/Parameters".stuff["number_anim_type"] == 3:
		$table2/Table_panel/start_print.disabled = true


func _on_Table_collision_body_exited(body):
	$table2/Table_panel.visible = false
	$table2/process_print.stop()
	$table2/Table_panel/print_bar.value = 0

func _on_process_print_timeout():
	$table2/Table_panel/print_bar.value+=1


func _on_start_print_pressed():
	if $"/root/Parameters".stuff["magazin_count"] > 0:
		$table2/process_print.start()
	play_button()


func _on_print_bar_value_changed(value):
	if $table2/Table_panel/print_bar.value == 100:
		$table2/process_print.stop()
		$table2/Table_panel/print_bar.value = 0
		$"/root/Parameters".stuff["magazin_count"] -= 1
		$table2.texture = sprite_table
		$Garage/Count_magazin.text = str($"/root/Parameters".stuff["magazin_count"])+"/"+str($"/root/Parameters".stuff["magazins_capacity"])
		$table2/Table_panel/start_print.visible = false
		$table2/Table_panel/take_ramki.visible = true

	
func _on_take_ramki_pressed():
	if $table2.texture == sprite_table:
		$table2.texture = sprite_table0
		$"/root/Parameters".stuff["number_anim_type"] = 3
		$table2/Table_panel/start_print.disabled = true
		$table2/Table_panel/start_print.visible = true
		$table2/Table_panel/take_ramki.visible = false
	play_button()
	
	

func _on_put_ramki_pressed():
	$Medogonka/Medogonka_panel/status/empty.visible = false
	$Medogonka/Medogonka_panel/status/ready.visible = true
	$Medogonka/Medogonka_panel/start_work.visible = true
	$Medogonka/Medogonka_panel/put_ramki.visible = false
	play_button()
	if $"/root/Parameters".stuff["moonwalk_bool"]:
		$"/root/Parameters".stuff["number_anim_type"] = 1
	else:
		$"/root/Parameters".stuff["number_anim_type"] = 0 
		

func _on_medogonka_trigger_body_entered(body):
	$Medogonka/Medogonka_panel.visible = true
	if $"/root/Parameters".stuff["buckets_count"] == 10:
		$Medogonka/Medogonka_panel/status/empty.visible = false
		$Medogonka/Medogonka_panel/put_ramki.disabled = true
		$Medogonka/Medogonka_panel/status/full_sklad.visible = true
	else:
		$Medogonka/Medogonka_panel/status/full_sklad.visible = false
		$Medogonka/Medogonka_panel/put_ramki.disabled = false
		$Medogonka/Medogonka_panel/status/empty.visible = true
	if $Medogonka/Medogonka_panel/status/works.visible == true or $Medogonka/Medogonka_panel/status/ready.visible == true:
		$Medogonka/Medogonka_panel/status/empty.visible = false
		$Medogonka/Medogonka_panel/put_ramki.visible = false
	if $"/root/Parameters".stuff["number_anim_type"] == 3:
		if $Medogonka/Medogonka_panel/status/works.visible == true or $Medogonka/Medogonka_panel/status/ready.visible == true:
			$Medogonka/Medogonka_panel/put_ramki.visible = false
		else:
			$Medogonka/Medogonka_panel/put_ramki.visible = true
			
	else:
		$Medogonka/Medogonka_panel/put_ramki.visible = false


func _on_medogonka_trigger_body_exited(body):
	$Medogonka/Medogonka_panel.visible = false


func _on_start_work_pressed():
	$Medogonka/AnimatedSprite.play("work")
	$Medogonka/Medogonka_panel/work_timer.start()
	$Medogonka/Medogonka_panel/start_work.visible = false
	$Medogonka/Medogonka_panel/status/ready.visible = false
	$Medogonka/Medogonka_panel/status/works.visible = true
	play_button()
	if $"/root/Parameters".stuff["sounds_bool"]:
		$Medogonka/medogonka_audio.play()
	


func _on_work_timer_timeout():
	$Medogonka/progress_bar.value+=1




func _on_progress_bar_value_changed(value):
	if $Medogonka/progress_bar.value == 100:
		$Medogonka/Medogonka_panel/work_timer.stop()
		$"/root/Parameters".stuff["buckets_count"] += 1
		$Garage/Count_buckets.text = str($"/root/Parameters".stuff["buckets_count"])+"/"+str($"/root/Parameters".stuff["buckets_capacity"])
		$Medogonka/AnimatedSprite.play("state")
		$Medogonka/Medogonka_panel/status/works.visible = false
		$Medogonka/Medogonka_panel/status/empty.visible = true
		$Medogonka/progress_bar.value = 0
		$Medogonka/medogonka_audio.stop()


func _on_Buckets_trigger_body_entered(body):
	if $"/root/Parameters".stuff["buckets_count"] == 0 or $"/root/Parameters".stuff["number_anim_type"] == 4:
		$Garage/Buckets_menu/take.disabled = true
	else:
		$Garage/Buckets_menu/take.disabled = false
	if $"/root/Parameters".stuff["number_anim_type"] == 4:
		$Garage/Buckets_menu/put.disabled = false
	else:
		$Garage/Buckets_menu/put.disabled = true
	$Garage/Buckets_menu.visible = true
	


func _on_Buckets_trigger_body_exited(body):
	$Garage/Buckets_menu.visible = false


func _on_take_pressed():
	$"/root/Parameters".stuff["buckets_count"] -= 1
	$Garage/Count_buckets.text = str($"/root/Parameters".stuff["buckets_count"])+"/"+str($"/root/Parameters".stuff["buckets_capacity"])
	$"/root/Parameters".stuff["number_anim_type"] = 4
	$Garage/Buckets_menu/put.disabled = false
	$Garage/Buckets_menu/take.disabled = true
	play_button()
	


func _on_put_pressed():
	$"/root/Parameters".stuff["buckets_count"] += 1
	$Garage/Count_buckets.text = str($"/root/Parameters".stuff["buckets_count"])+"/"+str($"/root/Parameters".stuff["buckets_capacity"])
	$Garage/Buckets_menu/put.disabled = true
	$Garage/Buckets_menu/take.disabled = false
	if $"/root/Parameters".stuff["moonwalk_bool"]:
		$"/root/Parameters".stuff["number_anim_type"] = 1
	else:
		$"/root/Parameters".stuff["number_anim_type"] = 0 
	play_button()


func _on_trashcan2_body_entered(body):
	$trashcan/throw_away.visible = true


func _on_trashcan2_body_exited(body):
	$trashcan/throw_away.visible = false


func _on_throw_away_pressed():
	if $"/root/Parameters".stuff["moonwalk_bool"]:
		$"/root/Parameters".stuff["number_anim_type"] = 1
	else:
		$"/root/Parameters".stuff["number_anim_type"] = 0 
	play_button()
	
func _on_litrs_trigger_body_entered(body):
	$Market/put_litrs.visible = true
	if $"/root/Parameters".stuff["number_anim_type"] != 4:
		$Market/put_litrs.disabled = true
	else:
		$Market/put_litrs.disabled = false


func _on_litrs_trigger_body_exited(body):
	$Market/put_litrs.visible = false
		


func _on_put_litrs_pressed():
	$"/root/Parameters".stuff["litrs_count"] += 30
	if $"/root/Parameters".stuff["litrs_count"] >= $"/root/Parameters".stuff["litrs_capacity"]:
		$"/root/Parameters".stuff["litrs_count"] = $"/root/Parameters".stuff["litrs_capacity"]
	$Market/Count_litrs.text = str($"/root/Parameters".stuff["litrs_count"])+"/"+str($"/root/Parameters".stuff["litrs_capacity"])
	if $"/root/Parameters".stuff["moonwalk_bool"]:
		$"/root/Parameters".stuff["number_anim_type"] = 1
	else:
		$"/root/Parameters".stuff["number_anim_type"] = 0 
	$Market/put_litrs.disabled = true
	play_button()

func _on_market_trigger_body_entered(body):
	$Market/start_torg.visible = true
	if $"/root/Parameters".stuff["litrs_count"] <= 0:
		$Market/start_torg.disabled = true
	else:
		$Market/start_torg.disabled = false


func _on_market_trigger_body_exited(body):
	$Market/start_torg.visible = false
	$Market/torg_time.stop()
	$Market/progress_torg.value = 0


func _on_Car_off_music():
	$fon.stop()


func _on_Car_on_music():
	$fon.play()


func _on_start_torg_pressed():
	$Market/torg_time.wait_time = $"/root/Parameters".stuff["torg_time"]
	$Market/torg_time.start()
	$Market/start_torg.disabled = true
	play_button()


func _on_torg_time_timeout():
	$Market/progress_torg.value += 1



func _on_progress_torg_value_changed(value):
	if $Market/progress_torg.value == 100:
		if $"/root/Parameters".stuff["litrs_count"] == 3:
			litrs_sell = 3
		elif $"/root/Parameters".stuff["litrs_count"] == 2:
			litrs_sell = 2
		elif $"/root/Parameters".stuff["litrs_count"] == 1:
			litrs_sell = 1
		else:
			rng.randomize()
			litrs_sell = rng.randi_range(1, 3)
		$"/root/Parameters".stuff["litrs_count"] -= litrs_sell
		$Market/Count_litrs.text = str($"/root/Parameters".stuff["litrs_count"])+"/"+str($"/root/Parameters".stuff["litrs_capacity"])
		$Market/progress_torg.value = 0
		$"/root/Parameters".stuff["money"] += litrs_sell*100
		$CanvasLayer/money.text = str($"/root/Parameters".stuff["money"])
		if $"/root/Parameters".stuff["litrs_count"] == 0:
			$Market/torg_time.stop()
		if $"/root/Parameters".stuff["money"] >= 1000000:
			$CanvasLayer/win.visible = true


func _on_STO_body_entered(body):
	$City/STO/Enter_STO.visible = true


func _on_STO_body_exited(body):
	$City/STO/Enter_STO.visible = false


func _on_BeeShop_body_entered(body):
	$City/BeeShop/Enter_BeeShop.visible = true


func _on_BeeShop_body_exited(body):
	$City/BeeShop/Enter_BeeShop.visible = false


func _on_Hardware_shop_body_entered(body):
	$City/Hardware_shop/Enter_HardWareShop.visible = true


func _on_Hardware_shop_body_exited(body):
	$City/Hardware_shop/Enter_HardWareShop.visible = false


func _on_Business_shop_body_entered(body):
	$City/Business_shop/Enter_BusinessShop.visible = true


func _on_Business_shop_body_exited(body):
	$City/Business_shop/Enter_BusinessShop.visible = false


func _on_Enter_STO_pressed():
	$"/root/Parameters".stuff["beekeeper_speed"] = 0
	$CanvasLayer/STO.visible = true
	compare_shop("STO","Plus_bagaj")
	compare_shop("STO","Plus_speed")
	play_button()


func _on_Close_STO_pressed():
	$"/root/Parameters".stuff["beekeeper_speed"] = 100
	$CanvasLayer/STO.visible = false
	play_button()


func _on_buy_bagaj_pressed():
	$"/root/Parameters".stuff["bagaj_capacity"] += 2
	play_button()
	compare_shop("STO","Plus_bagaj")
	minus_money("STO","Plus_bagaj")



func _on_buy_speed_pressed():
	minus_money("STO","Plus_speed")
	$"/root/Parameters".stuff["car_speed"] += 25
	play_button()
	compare_shop("STO","Plus_speed")


func _on_Enter_BusinessShop_pressed():
	$"/root/Parameters".stuff["beekeeper_speed"] = 0
	$CanvasLayer/Bussines_shop.visible = true
	play_button()
	compare_shop("Bussines_shop","plus_torg_time")


func _on_Close_bussines_shop_pressed():
	$"/root/Parameters".stuff["beekeeper_speed"] = 100
	$CanvasLayer/Bussines_shop.visible = false
	play_button()

func _on_plus_torg_time_pressed():
	minus_money("Bussines_shop","plus_torg_time")
	$"/root/Parameters".stuff["torg_time"] -= 0.005
	play_button()
	compare_shop("Bussines_shop","plus_torg_time")


func _on_Enter_BeeShop_pressed():
	$"/root/Parameters".stuff["beekeeper_speed"] = 0
	$CanvasLayer/BeeShop.visible = true
	compare_shop("BeeShop","plus_work_time")
	compare_shop("BeeShop","plus_print_time")
	compare_shop("BeeShop","plus_uley")
	compare_shop("BeeShop","plus_full_fill_time")
	if $"/root/Parameters".stuff["number_of_uley"] == 16:
		$CanvasLayer/BeeShop/plus_uley/plus_uley.disabled = true
	if $"/root/Parameters".stuff["full_fill_time"] == 6:
		$CanvasLayer/BeeShop/plus_full_fill_time/plus_full_fill_time.visible = false
		$CanvasLayer/BeeShop/plus_full_fill_time/max_lvl.visible = true
	play_button()

func _on_Close_beeshop_pressed():
	$"/root/Parameters".stuff["beekeeper_speed"] = 100
	$CanvasLayer/BeeShop.visible = false
	play_button()

func _on_plus_work_time_pressed():
	minus_money("BeeShop","plus_work_time")
	$"/root/Parameters".stuff["work_time"] -= 0.005
	play_button()
	compare_shop("BeeShop","plus_work_time")


func _on_plus_print_time_pressed():
	minus_money("BeeShop","plus_print_time")
	$"/root/Parameters".stuff["work_time"] -= 0.002
	play_button()
	compare_shop("BeeShop","plus_print_time")


func _on_plus_uley_pressed():
	minus_money("BeeShop","plus_uley")
	get_node("Apiary/Uley"+str($"/root/Parameters".stuff["number_of_uley"])).visible = true
	$"/root/Parameters".stuff["number_of_uley"] += 1
	play_button()
	compare_shop("BeeShop","plus_uley")
	if $"/root/Parameters".stuff["number_of_uley"] == 16:
		$CanvasLayer/BeeShop/plus_uley/plus_uley.disabled = true


func _on_plus_full_fill_time_pressed():
	minus_money("BeeShop","plus_full_fill_time")
	$"/root/Parameters".stuff["full_fill_time"] -= 3
	for i in range(1, $"/root/Parameters".stuff["number_of_uley"]):
		get_node("Apiary/Uley"+str(i)+"/Panel/time_full_fill").wait_time = $"/root/Parameters".stuff["full_fill_time"]
	play_button()
	compare_shop("BeeShop", "plus_full_fill_time")
	if $"/root/Parameters".stuff["full_fill_time"] == 6:
		$CanvasLayer/BeeShop/plus_full_fill_time/plus_full_fill_time.visible = false
		$CanvasLayer/BeeShop/plus_full_fill_time/max_lvl.visible = true


func _on_Close_hardwareshop_pressed():
	play_button()
	$CanvasLayer/HardWareShop.visible = false


func _on_Enter_HardWareShop_pressed():
	$CanvasLayer/HardWareShop.visible = true
	compare_shop("HardWareShop", "plus_buckets_capacity")
	compare_shop("HardWareShop", "plus_litrs_capacity")
	compare_shop("HardWareShop", "plus_magazins_capacity")
	play_button()


func _on_plus_buckets_capacity_pressed():
	minus_money("HardWareShop", "plus_buckets_capacity")
	play_button()
	compare_shop("HardWareShop", "plus_buckets_capacity")
	$"/root/Parameters".stuff["buckets_capacity"] += 5
	$Garage/Count_buckets.text = str($"/root/Parameters".stuff["buckets_count"])+"/"+str($"/root/Parameters".stuff["buckets_capacity"])
	


func _on_plus_litrs_capacity_pressed():
	minus_money("HardWareShop", "plus_litrs_capacity")
	play_button()
	$"/root/Parameters".stuff["litrs_capacity"] += 150
	$Market/Count_litrs.text = str($"/root/Parameters".stuff["litrs_count"])+"/"+str($"/root/Parameters".stuff["litrs_capacity"])
	compare_shop("HardWareShop", "plus_litrs_capacity")


func _on_plus_magazins_capacity_pressed():
	minus_money("HardWareShop", "plus_magazins_capacity")
	play_button()
	$"/root/Parameters".stuff["magazins_capacity"] += 5
	$Garage/Count_magazin.text = str($"/root/Parameters".stuff["magazin_count"])+"/"+str($"/root/Parameters".stuff["magazins_capacity"])
	compare_shop("HardWareShop", "plus_magazins_capacity")


func _on_pause_pressed():
	$CanvasLayer/pause.visible = false
	$CanvasLayer/pause_menu.visible = true
	$"/root/Parameters".stuff["beekeeper_speed"] = 0
	play_button()


func _on_continue_pressed():
	$CanvasLayer/pause.visible = true
	$CanvasLayer/pause_menu.visible = false
	$"/root/Parameters".stuff["beekeeper_speed"] = 100
	play_button()
	



func _on_save_pressed():
	var fileSave = File.new()
	$"/root/Parameters".stuff["time"] = OS.get_unix_time()
	print($"/root/Parameters".stuff["time"])
	for i in range(1, 16):
		$"/root/Parameters".stuff["uley"+str(i)] = get_node("Apiary/Uley"+str(i)+"/Panel/Full_med").value
	var temp = $"/root/Parameters".stuff
	fileSave.open("user://save.json", File.WRITE)
	fileSave.store_string(to_json(temp))
	fileSave.close()
	play_button()
	


func _on_exit_pressed():
	var fileSave = File.new()
	$"/root/Parameters".stuff["time"] = OS.get_unix_time()
	for i in range(1, 16):
		$"/root/Parameters".stuff["uley"+str(i)] = get_node("Apiary/Uley"+str(i)+"/Panel/Full_med").value
	var temp = $"/root/Parameters".stuff
	fileSave.open("user://save.json", File.WRITE)
	fileSave.store_string(to_json(temp))
	fileSave.close()
	play_button()
	get_tree().change_scene("res://Scenes/main_menu.tscn")


func _on_change_ostatok_timeout():
	for i in range(1, 16):
		var s = (100-get_node("Apiary/Uley"+str(i)+"/Panel/Full_med").value)*$"/root/Parameters".stuff["full_fill_time"]
		var minut = int(s / 60)
		get_node("Apiary/Uley"+str(i)+"/Panel/ostatok").text = "Осталось " + str(minut) + "мин"


func _on_next_pressed():
	$CanvasLayer/win.visible = false
