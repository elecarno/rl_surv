extends MeshInstance3D

@export var on_ground: bool = false

func _process(delta: float) -> void:
	if !on_ground:
		if Input.is_action_just_pressed("act_interact"):
			position = Vector3(0, -0.1, -0.75)
			rotation_degrees = Vector3(80, 0, 0)
		if Input.is_action_just_released("act_interact"):
			position = Vector3(0, -0.3, -0.25)
			rotation_degrees = Vector3(10, 0, 0)
