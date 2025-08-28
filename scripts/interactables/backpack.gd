extends LargeInteract

var data: Backpack
	
func _ready() -> void:
	$interface/main.contents = data.main
	$interface/top.contents = data.top


func use_backpack():
	data.main = $interface/main.contents
	data.top = $interface/top.contents
	get_parent().get_node("player").backpack_res = data
	queue_free()
