extends ItemFunction

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("act_interact") and !on_ground:
		if ($"../../../..".is_holding 
		and $"../../../..".holding.item.type == self.name
		and $"../../../..".mode_interact):
			var ray_col = $"../../ray_small".get_collider()
			
			if ray_col is SmallInteract and ray_col.type == "tent_pole":
				ray_col.toggle_pole()
				if ray_col.has_pole:
					print("removed pole from item")
					$"../../../..".holding.contents -= 1
				else:
					print("added pole to item")
					$"../../../..".holding.contents += 1
