extends MeshInstance3D

# scale:
# 0 = -20C
# 1 = 40C

# y = x/60 + 1/3

func _process(_delta: float) -> void:
	var target_height: float = (world.temp_alt*0.016) + 0.33
	var target_scale: Vector3 = Vector3(1, 1, target_height)
	$fluid.scale = target_scale
	
	#print("alt: %.2f, scale: %.2f" % [world.temp_alt, target_height])
