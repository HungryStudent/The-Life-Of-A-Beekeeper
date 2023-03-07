extends KinematicBody2D

var anim_types = [["blue_tshirt_up","blue_tshirt_down","blue_tshirt_left","blue_tshirt_right","blue_tshirt_state"],
				["blue_tshirt_down","blue_tshirt_up","blue_tshirt_right","blue_tshirt_left","blue_tshirt_state"],
				["with_magazin_up","with_magazin_down","with_magazin_left","with_magazin_right","with_magazin_state"],
				["with_ramki_up","with_ramki_down","with_ramki_left","with_ramki_right","with_ramki_state"],
				["with_bucket_up","with_bucket_down","with_bucket_left","with_bucket_right","with_bucket_state"]]

var inv
var velocity = Vector2()
var anim_type
var number_anim_type = 0

signal fix_ui
signal plus_magazin
signal medogonka_ready

func _ready():
	var time = OS.get_time()
	$"/root/Parameters".stuff["beekeeper_speed"] = 100
	if $"/root/Parameters".stuff["moonwalk_bool"] == true:
		$"/root/Parameters".stuff["number_anim_type"] = 1
	else:
		$"/root/Parameters".stuff["number_anim_type"] = 0

func get_input():
	if $"/root/Parameters".stuff["car_active"] == false:
		velocity = Vector2()
		if Input.is_action_pressed("player_right"):
			velocity.x += 1
			anim_type = anim_types[$"/root/Parameters".stuff["number_anim_type"]][3]
			$maska.position.x = 0.936
			$maska.position.y = 0
			$maska.scale.x = 0.131
			$maska.scale.y = 0.131
		if Input.is_action_pressed("player_left"):
			velocity.x -= 1
			anim_type = anim_types[$"/root/Parameters".stuff["number_anim_type"]][2]
			$maska.position.x = 2
			$maska.position.y = 0
			$maska.scale.x = 0.131
			$maska.scale.y = 0.131
		if Input.is_action_pressed("player_down"):
			velocity.y += 1
			anim_type = anim_types[$"/root/Parameters".stuff["number_anim_type"]][1]
			$maska.position.x = 0
			$maska.position.y = 0
			$maska.scale.x = 0.114
			$maska.scale.y = 0.114
		if Input.is_action_pressed("player_up"):
			velocity.y -= 1
			anim_type = anim_types[$"/root/Parameters".stuff["number_anim_type"]][0]
			$maska.position.x = 0
			$maska.position.y = 0
			$maska.scale.x = 0.114
			$maska.scale.y = 0.114
		velocity = velocity.normalized() * $"/root/Parameters".stuff["beekeeper_speed"]
		if velocity != Vector2(0,0):
			$AnimatedSprite.play(anim_type)
		else:
			$AnimatedSprite.play(anim_types[$"/root/Parameters".stuff["number_anim_type"]][4])
			$maska.position.x = 0
			$maska.position.y = 0
			$maska.scale.x = 0.114
			$maska.scale.y = 0.114
func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)





func _on_bag_fix_body_entered(body):
	emit_signal("fix_ui")
	$maska.visible = false


func _on_Uley1_with_magazin():
	$"/root/Parameters".stuff["number_anim_type"] = 2
	$"/root/Parameters".stuff["beekeeper_speed"] = 80

func _on_Car_beekeeper_off():
	$AnimatedSprite.visible = false
	$CollisionShape2D.disabled = true
	$Camera2D.rotating = false
	$Camera2D.current = false

func _on_Car_beekeeper_on(pos):
	position = pos
	$AnimatedSprite.visible = true
	$CollisionShape2D.disabled = false
	$Camera2D.rotating = true
	$Camera2D.current = true

func _on_all_body_entered(body):
	$maska.visible = true

func _on_all_body_exited(body):
	$maska.visible = false

func _on_Magazins_trigger_body_entered(body):
	if $"/root/Parameters".stuff["number_anim_type"] == 2:
		if $"/root/Parameters".stuff["moonwalk_bool"]:
			$"/root/Parameters".stuff["number_anim_type"] = 1
		else:
			$"/root/Parameters".stuff["number_anim_type"] = 0  
		$"/root/Parameters".stuff["beekeeper_speed"] = 100
		emit_signal("plus_magazin")
