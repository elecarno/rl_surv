extends ItemFunction

func _process(delta: float) -> void:
	var target_rot: Vector3
	if !on_ground:
		target_rot= -$"../../..".global_rotation # references player head
	else:
		target_rot= Vector3(0, -$"../..".global_rotation.y, 0) # references item rigidbody
		
	#var wobble_rot = Vector3(0, target_rot.y + randf_range(-0.05, 0.05), 0)
	$needle.rotation = lerp($needle.rotation, target_rot, delta * 1.5)
