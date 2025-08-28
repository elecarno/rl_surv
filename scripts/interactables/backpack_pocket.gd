extends SmallInteract

# handles the individual interactable pockets of the placed backpack

# the storage space of the pocket
# - each item has a size value, the sum of those values cannot exceed the size
#   of the pocket
@export var section: String = "pocket"
@export var size: int = 128

var contents: Array[Item]

func _ready() -> void:
	print(section + " placed with " + str(contents.size()) + " items:")
	print(contents)

func extract_item():
	print("removing " + contents[0].display_name + " from " + section)
	contents.remove_at(0)
	
func insert_item(item: Item):
	contents.append(item)
	print("added " + item.type + " to " + section)
	
func get_used_capacity() -> int:
	var used: int = 0
	for i in contents.size():
		used += contents[i].size
	return used

# handle allowed/disallowed items somehow
