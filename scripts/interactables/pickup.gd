extends RigidBody3D
class_name Pickup

@export var res: Item
@export var wet: bool = false

func pickup_item():
	queue_free()
