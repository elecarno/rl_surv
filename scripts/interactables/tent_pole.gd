extends SmallInteract

var has_pole: bool = false

func toggle_pole():
	has_pole = !has_pole
	
	if has_pole:
		# TODO: show pole model
		prompt_message = "Remove Tent Pole"
	else:
		# TODO: hide pole model
		prompt_message = "Add Tent Pole"
