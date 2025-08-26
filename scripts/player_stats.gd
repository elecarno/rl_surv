extends Node3D

# All meters are setup as percentages where 1.0 = 100%
# Temperatures are in degrees celsius where 0 = freezing (0C)

var stamina: float = 1.0
var STAMINA_REGEN: float = 0.1
var STAMINA_DRAIN: float = 0.15
var can_sprint: bool = true

var water: float = 1.0
var energy: float = 1.0
var nutrition: float = 1.0
var morale: float = 1.0

# body parts
var body: Dictionary = {
	"hp_head": 1.0,
	"temp_head": 15.0,
	
	"hp_torso_upper": 1.0,
	"hp_torso_lower": 1.0,
	"temp_torso": 20.0,
	
	"hp_l_arm_upper": 1.0,
	"hp_l_arm_lower": 1.0,
	"hp_l_hand": 1.0,
	"temp_l_arm": 18.0,
	"temp_l_hand": 15.0,
	
	"hp_r_arm_upper": 1.0,
	"hp_r_arm_lower": 1.0,
	"hp_r_hand": 1.0,
	"temp_r_arm": 18.0,
	"temp_r_hand": 15.0,
	
	"hp_l_leg_upper": 1.0,
	"hp_l_leg_lower": 1.0,
	"hp_l_foot": 1.0,
	"temp_l_leg": 18.0,
	"temp_l_foot": 18.0,
	
	"hp_r_leg_upper": 1.0,
	"hp_r_leg_lower": 1.0,
	"hp_r_foot": 1.0,
	"temp_r_leg": 18.0,
	"temp_r_foot": 18.0
}

func _process(delta):
	if Input.is_action_pressed("mov_sprint") and can_sprint:
		stamina -= STAMINA_DRAIN * delta
	else:
		if stamina < 1.0:
			stamina += STAMINA_REGEN * delta
			
func take_damage(damage: float):
	pass
