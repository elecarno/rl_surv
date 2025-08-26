extends Control

func _process(delta):
	if Input.is_action_just_pressed("debug_stats"):
		visible = !visible
		
	$status/timestamp.text = world.format_time()
	$status/conditions.text = "temp_sea: %.2f
	temp_alt: %.2f

	weather: %s

	wind_speed: %.2f
	wind_dir: %.2f" % [
		world.temp_sea,
		world.temp_alt,
		world.weather_current,
		world.wind_speed,
		world.wind_dir
	]
	
	$status/meters.text = "water: %.2f
	energy: %.2f
	nutrition: %.2f
	morale: %.2f
	stamina: %.2f" % [
		player_stats.water * 100,
		player_stats.energy * 100,
		player_stats.nutrition * 100,
		player_stats.morale * 100,
		player_stats.stamina * 100
	]
	
	var body_stats = player_stats.body
	
	$body/hp_head.text = str(body_stats["hp_head"] * 100) + "%"
	$body/temp_head.text = str(body_stats["temp_head"]) + "C"
	
	$body/hp_torso_upper.text = str(body_stats["hp_torso_upper"] * 100) + "%"
	$body/hp_torso_lower.text = str(body_stats["hp_torso_lower"] * 100) + "%"
	$body/temp_torso.text = str(body_stats["temp_torso"])  + "C"
	
	$body/hp_r_arm_upper.text = str(body_stats["hp_r_arm_upper"] * 100) + "%"
	$body/hp_r_arm_lower.text = str(body_stats["hp_r_arm_lower"] * 100) + "%"
	$body/temp_r_arm.text = str(body_stats["temp_r_arm"]) + "C"
	$body/hp_r_hand.text = str(body_stats["hp_r_hand"] * 100) + "%"
	$body/temp_r_hand.text = str(body_stats["temp_r_hand"]) + "C"
	
	$body/hp_l_arm_upper.text = str(body_stats["hp_l_arm_upper"] * 100) + "%"
	$body/hp_l_arm_lower.text = str(body_stats["hp_l_arm_lower"] * 100) + "%"
	$body/temp_l_arm.text = str(body_stats["temp_l_arm"]) + "C"
	$body/hp_l_hand.text = str(body_stats["hp_l_hand"] * 100) + "%"
	$body/temp_l_hand.text = str(body_stats["temp_l_hand"]) + "C"
	
	$body/hp_r_leg_upper.text = str(body_stats["hp_r_leg_upper"] * 100) + "%"
	$body/hp_r_leg_lower.text = str(body_stats["hp_r_leg_lower"] * 100) + "%"
	$body/temp_r_leg.text = str(body_stats["temp_r_leg"]) + "C"
	$body/hp_r_foot.text = str(body_stats["hp_r_foot"] * 100) + "%"
	$body/temp_r_foot.text = str(body_stats["temp_r_foot"]) + "C"
	
	$body/hp_l_leg_upper.text = str(body_stats["hp_l_leg_upper"] * 100) + "%"
	$body/hp_l_leg_lower.text = str(body_stats["hp_l_leg_lower"] * 100) + "%"
	$body/temp_l_leg.text = str(body_stats["temp_l_leg"]) + "C"
	$body/hp_l_foot.text = str(body_stats["hp_l_foot"] * 100) + "%"
	$body/temp_l_foot.text = str(body_stats["temp_l_foot"]) + "C"
	
