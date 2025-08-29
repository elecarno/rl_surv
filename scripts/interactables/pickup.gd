extends RigidBody3D
class_name Pickup

@export var res: ItemInstance
@export var wet: bool = false

func _ready() -> void:
	mass = res.item.weight
	
	if $items.has_node(res.item.type):
		var children = $items.get_children()
		for i in children.size():
			if $items.get_child(i).name != res.item.type:
				$items.get_child(i).queue_free()
		$items.get_node(res.item.type).visible = true
	else:
		$items/default.visible = true

func pickup_item():
	queue_free()
