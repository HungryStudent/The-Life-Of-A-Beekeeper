extends KinematicBody2D

var anim_types = ["up", "down", "left", "right"]
var camera = preload("res://Scenes/Camera2D.tscn")
var velocity = Vector2()
var anim_type = anim_types[2]


signal beekeeper_off
signal beekeeper_on(pos)
signal no_with_bucket
signal off_music
signal on_music

func _ready():
	$Trunk/Count_buckets.text = "Вёдра: " + str($"/root/Parameters".stuff["buckets_in_car"]) +"/"+ str($"/root/Parameters".stuff["bagaj_capacity"])

func get_input():
	velocity = Vector2()
	if $"/root/Parameters".stuff["car_active"]:
		if Input.is_action_pressed("player_down"):
			velocity.y += 1
			anim_type = anim_types[1]
			$CollisionShape2D.shape.set("extents", Vector2(19, 29))
			$BeeKeeper_in_trigger/CollisionShape2D.shape.set("extents", Vector2(20, 30))
		if Input.is_action_pressed("player_up"):
			velocity.y -= 1
			anim_type = anim_types[0]
			$CollisionShape2D.shape.set("extents", Vector2(19, 29))
			$BeeKeeper_in_trigger/CollisionShape2D.shape.set("extents", Vector2(20, 30))
		if Input.is_action_pressed("player_right"):
			velocity.x += 1
			anim_type = anim_types[3]
			$CollisionShape2D.shape.set("extents", Vector2(32, 19))
			$BeeKeeper_in_trigger/CollisionShape2D.shape.set("extents", Vector2(33, 20))
		if Input.is_action_pressed("player_left"):
			velocity.x -= 1
			anim_type = anim_types[2]
			$CollisionShape2D.shape.set("extents", Vector2(32, 19))
			$BeeKeeper_in_trigger/CollisionShape2D.shape.set("extents", Vector2(33, 20))
			
		velocity = velocity.normalized() * $"/root/Parameters".stuff["car_speed"]
		if velocity != Vector2(0,0):
			$AnimatedSprite.play(anim_type)
			$Out.visible = false
		else:
			$AnimatedSprite.play(anim_type)
			$Out.visible = true
			
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func play_button():
	if $"/root/Parameters".stuff["sounds_bool"]:
		$"/root/Parameters/button_sound".play()
		

func _on_BeeKeeper_in_trigger_body_entered(body):
	$In.visible = true
	$Open_trunk.visible = true
	
func _on_BeeKeeper_in_trigger_body_exited(body):
	$In.visible = false
	$Open_trunk.visible = false
	$Trunk.visible = false
	
func _on_BeeKepeer_fix_ui():
	$In.visible = false
	$Out.visible = false
	$Open_trunk.visible = false
	
	

func _on_In_pressed():
	$"/root/Parameters".stuff["car_active"] = true
	emit_signal("beekeeper_off")
	$Camera2D.current = true
	$Camera2D.current = true
	$In.visible = false
	$Open_trunk.visible = false
	$Trunk.visible = false
	if $"/root/Parameters".stuff["music_bool"]:
		$auto_music.play()
		emit_signal(("off_music"))
	if $"/root/Parameters".stuff["sounds_bool"]:
		$work.play()

	$BeeKeeper_in_trigger/CollisionShape2D.disabled = true
	play_button()

func _on_Out_pressed():
	$"/root/Parameters".stuff["car_active"] = false
	emit_signal("beekeeper_on", position)
	$Camera2D.current = false
	$Camera2D.current = false
	$Out.visible = false
	$In.visible = false
	$BeeKeeper_in_trigger/CollisionShape2D.disabled = false
	if $"/root/Parameters".stuff["music_bool"]:
		$auto_music.stop()
		emit_signal("on_music")
	$work.stop()
	play_button()
	





func _on_Open_trunk_pressed():
	$Out.visible = false
	$In.visible = false
	$Open_trunk.visible = false
	$Trunk.visible = true
	$Trunk/Count_buckets.text = "Вёдра: " + str($"/root/Parameters".stuff["buckets_in_car"]) +"/"+ str($"/root/Parameters".stuff["bagaj_capacity"])
	if $"/root/Parameters".stuff["buckets_in_car"] == 0 or $"/root/Parameters".stuff["number_anim_type"] == 4:
		$Trunk/Take.disabled = true
	else:
		$Trunk/Take.disabled = false
	if $"/root/Parameters".stuff["number_anim_type"] == 4 and $"/root/Parameters".stuff["buckets_in_car"] <= $"/root/Parameters".stuff["bagaj_capacity"]:
		$Trunk/Put.disabled = false
	else:
		$Trunk/Put.disabled = true
	play_button()


func _on_Close_pressed():
	$In.visible = true
	$Open_trunk.visible = true
	$Trunk.visible = false
	play_button()
	
	
func _on_Put_pressed():
	if $"/root/Parameters".stuff["moonwalk_bool"]:
		$"/root/Parameters".stuff["number_anim_type"] = 1
	else:
		$"/root/Parameters".stuff["number_anim_type"] = 0 
	$"/root/Parameters".stuff["buckets_in_car"] += 1
	$Trunk/Count_buckets.text = "Вёдра: " + str($"/root/Parameters".stuff["buckets_in_car"]) +"/"+ str($"/root/Parameters".stuff["bagaj_capacity"])
	$Trunk/Put.disabled = true
	$Trunk/Take.disabled = false
	play_button()
	

func _on_Take_pressed():
	$"/root/Parameters".stuff["number_anim_type"] = 4
	$"/root/Parameters".stuff["buckets_in_car"] -= 1
	$Trunk/Count_buckets.text = "Вёдра: " + str($"/root/Parameters".stuff["buckets_in_car"]) +"/"+ str($"/root/Parameters".stuff["bagaj_capacity"])
	$Trunk/Put.disabled = false
	$Trunk/Take.disabled = true
	play_button()
