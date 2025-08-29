extends Node3D

@onready var watch: MeshInstance3D = get_node("watch")

func hide_all():
	var items = self.get_children()
	for i in items.size():
		if items[i].name != "watch":
			self.get_child(i).visible = false
		
func show_item(item: String):
	hide_all()
	if self.has_node(item):
		self.get_node(item).visible = true
	else:
		self.get_node("item").visible = true

func _process(delta: float) -> void:
	# watch
	if Input.is_action_just_pressed("hud_watch"):
		watch.visible = true
	if Input.is_action_just_released("hud_watch"):
		watch.visible = false
	
	var minute_rot = (360/60) * world.minute_ref
	var hour_rot = (((2 * PI) / 12) * world.hour_ref) + (((2 * PI) / 720) * world.minute_ref)
	watch.get_node("hand_minute").rotation_degrees = Vector3(0, -minute_rot, 0)
	watch.get_node("hand_hour").rotation = Vector3(0, -hour_rot, 0)
