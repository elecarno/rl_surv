extends SmallInteract

# handles the individual interactable pockets of the placed backpack

# the storage space of the pocket
# - each item has a size value, the sum of those values cannot exceed the size
#   of the pocket
@export var section: String = "pocket"
@export var size: int = 128
@export var whitelist: Array[String] = []
@export var strap: bool = false
@export var display_mesh: MeshInstance3D

var contents: Array[ItemInstance]

func initialise():
	print(section + " placed with " + str(contents.size()) + " items:")
	
	if strap and contents.size() == 0:
		display_mesh.visible = false

func extract_item():
	print("removing " + contents[0].item.display_name + " from " + section)
	contents.remove_at(0)
	
	if strap:
		display_mesh.visible = false
	
func insert_item(item: ItemInstance):
	contents.insert(0, item)
	print("added " + item.item.type + " to " + section)
	
	if strap:
		display_mesh.visible = true
	
func get_used_capacity() -> int:
	var used: int = 0
	for i in contents.size():
		used += contents[i].item.size
	return used

# handle allowed/disallowed items somehow
