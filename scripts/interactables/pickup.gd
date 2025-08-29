extends RigidBody3D
class_name Pickup

@export var res: Item
@export var wet: bool = false

func _ready() -> void:
	mass = res.weight
	
	if $items.has_node(res.type):
		var children = $items.get_children()
		for i in children.size():
			if $items.get_child(i).name != res.type:
				$items.get_child(i).queue_free()
		$items.get_node(res.type).visible = true
	else:
		$items/default.visible = true

func pickup_item():
	queue_free()
