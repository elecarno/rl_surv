extends RigidBody3D
class_name Pickup

@export var res: Item
@export var wet: bool = false

func _ready() -> void:
	mass = res.weight

func pickup_item():
	queue_free()
