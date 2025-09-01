extends SmallInteract

var has_peg: bool = false

func toggle_peg():
	has_peg = !has_peg
	
	if has_peg:
		$peg.visible = true
		print("added peg to tent")
		prompt_message = "Remove Tent Peg"
	else:
		$peg.visible = false
		print("removed peg from tent")
		prompt_message = "Add Tent Peg"
