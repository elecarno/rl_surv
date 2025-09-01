extends ItemFunction

@onready var tent = preload("res://prefabs/tent.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("item_use") and !on_ground:
		if $"../../../..".is_holding and $"../../../..".holding.item.type == self.name:
			var ray_col = $"../../ray_large".get_collider()
			var ray_pos = $"../../ray_large".get_collision_point()
			
			if ray_col != null:
				if ray_col.is_in_group("ground"):
					var tent_inst = tent.instantiate()
					tent_inst.position = ray_pos
					tent_inst.res = $"../../../..".holding
					tent_inst.rotation = $"../../..".rotation
					$"../../../..".get_parent().add_child(tent_inst)
					
					$"../../../..".holding = null
					$"../../../..".is_holding = false
