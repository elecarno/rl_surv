extends SmallInteract

var has_pole: bool = false

func toggle_pole():
	has_pole = !has_pole
	
	if has_pole:
		$pole.visible = true
		print("added pole to tent")
		prompt_message = "Remove Tent Pole"
	else:
		$pole.visible = false
		print("removed pole from tent")
		prompt_message = "Add Tent Pole"
