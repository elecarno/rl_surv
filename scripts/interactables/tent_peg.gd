extends SmallInteract

var has_pole: bool = false

func toggle_peg():
	has_pole = !has_pole
	
	if has_pole:
		$peg.visible = true
		print("added peg to tent")
		prompt_message = "Remove Tent Peg"
	else:
		$peg.visible = false
		print("removed peg from tent")
		prompt_message = "Add Tent Peg"
