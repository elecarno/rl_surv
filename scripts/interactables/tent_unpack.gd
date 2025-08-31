extends SmallInteract

var is_packed: bool = true

func _process(delta: float) -> void:
	if ($"../interface/pole1".has_pole or 
		$"../interface/pole2".has_pole or
		$"../interface/pole3".has_pole ):
			self.visible = false
			$col.disabled = false
	else:
		self.visible = true
		$col.disabled = false
		
func toggle_pack():
	if is_packed:
		$"../col".disabled = true
		$"../mesh".visible = false
		$"../interface".visible = true
		toggle_interface(true)
		is_packed = false
		prompt_message = "Pack Tent"
	else:
		$"../col".disabled = false
		$"../mesh".visible = true
		$"../interface".visible = false
		toggle_interface(false)
		is_packed = true
		prompt_message = "Unpack Tent"

func toggle_interface(state: bool):
	$"../interface/pole1/col".disabled = !state
	$"../interface/pole2/col".disabled = !state
	$"../interface/pole3/col".disabled = !state
	
