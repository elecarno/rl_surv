extends LargeInteract

# Handles the data of the placed down backpack

var data: Backpack
	
func _ready() -> void:
	$interface/main.contents = data.main
	$interface/top.contents = data.top
	$interface/top_strap.contents = data.top_strap
	$interface/right_pocket.contents = data.right_pocket
	$interface/right_strap.contents = data.right_strap
	$interface/left_strap.contents = data.left_strap
	
	$interface/main.initialise()
	$interface/top.initialise()
	$interface/top_strap.initialise()
	$interface/right_pocket.initialise()
	$interface/right_strap.initialise()
	$interface/left_strap.initialise()
	
	
func use_backpack():
	data.main = $interface/main.contents
	data.top = $interface/top.contents
	data.top_strap = $interface/top_strap.contents
	data.right_pocket = $interface/right_pocket.contents
	data.right_strap = $interface/right_strap.contents
	data.left_strap = $interface/left_strap.contents
	
	get_parent().get_node("player").backpack_res = data
	queue_free()
