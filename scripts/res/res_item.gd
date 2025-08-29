extends Resource
class_name Item

@export var type: String = "default"
@export var display_name: String = "Default"
@export var size: int = 16
@export var weight: float = 1.0 # in kg

# food & water stats
@export var is_water_container: bool = false
@export var is_food: bool = false
@export var has_wrapper: bool = false # decides whether the item is destroyed 
									  # or not when fully eaten

@export var MAX_CONTENTS: int = 0 #*
@export var WET_MASS: float = 0.0 # the mass added by contents being at max (in kg)
@export var energy: float = 0.0 # per bite
@export var nutrition: float = 0.0 # per bite

#* represents the number of times it can be drunk or consumed before being used up

# if weight is over 3kg then slow player down while holding it
