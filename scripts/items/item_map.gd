extends ItemFunction

func _process(_delta: float) -> void:
	if !on_ground:
		if Input.is_action_just_pressed("item_use"):
			position = Vector3(0, -0.1, -0.75)
			rotation_degrees = Vector3(80, 0, 0)
		if Input.is_action_just_released("item_use"):
			position = Vector3(0, -0.3, -0.25)
			rotation_degrees = Vector3(10, 0, 0)
