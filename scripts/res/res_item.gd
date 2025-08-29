extends Resource
class_name Item

@export var type: String = "default"
@export var display_name: String = "Default"
@export var size: int = 16
@export var weight: float = 1.0 # in kg

# if weight is over 3kg then slow player down while holding it
