extends MeshInstance3D

@export var on_ground: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("item_use") and !on_ground:
		if $"../../../..".is_holding and $"../../../..".holding.item.type == self.name:
			if $"../../../..".holding.contents > 0:
				$"../../../..".holding.contents -= 1
				
				if $"../../../..".holding.item.is_water_container:
					player_stats.modify_stat("water", 0.0625)
					print("drank water: " + str($"../../../..".holding.contents))
				
				if $"../../../..".holding.item.is_food:
					player_stats.modify_stat("energy", $"../../../..".holding.item.energy)
					player_stats.modify_stat("nutrition", $"../../../..".holding.item.nutrition)
					print("eaten food: " + str($"../../../..".holding.contents))
					
					if $"../../../..".holding.contents <= 0 and !$"../../../..".holding.item.has_wrapper:
						$"../../../..".holding = null
						$"../../../..".is_holding = false
						print("food used up")
