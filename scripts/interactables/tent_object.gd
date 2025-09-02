extends LargeInteract

var res: ItemInstance

func _ready() -> void:
	$col.visible = true
	$mesh.visible = true
	$interface.visible = false
	$flattened.visible = true
	
func use_tent():
	get_parent().get_node("player").holding = res
	get_parent().get_node("player").is_holding = true
	queue_free()
