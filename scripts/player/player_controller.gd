extends CharacterBody3D

# main
var speed: float
const WALK_SPEED: float = 4.0
const SPRINT_SPEED: float = 8.0
const CROUCH_SPEED: float = 1.5
const JUMP_VELOCITY: float = 6.0
const SENSITIVITY: float = 0.005
var grounded: bool = false
var crouched: bool = false

# head bob
const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.08
var t_bob: float = 0.0

# fov
const BASE_FOV: float = 70.0
const ZOOM_FOV: float = 55.0
const FOV_CHANGE: float = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 19.6

var mode_interact: bool = false
var placed_backpack: bool = false
var is_holding: bool = false
var holding: Item

@onready var empty_backpack: Backpack = preload("res://res/backpack_empty.tres")
@export var backpack_res: Backpack

@onready var head: Node3D = get_node("head")
@onready var cam: Camera3D = get_node("head/cam")
@onready var coyote_timer: Timer = get_node("coyote_time")
@onready var sprint_cooldown_timer: Timer = get_node("sprint_cooldown")
@onready var col: CollisionShape3D = get_node("col")
@onready var sfx: player_sfx = get_node("head/sfx")
@onready var ray_large: RayCast3D = get_node("head/cam/ray_large")
@onready var ray_small: RayCast3D = get_node("head/cam/ray_small")

@onready var lab_prompt: Label = get_parent().get_node("ui/hud/prompt")
@onready var lab_holding: Label = get_parent().get_node("ui/hud/item")
@onready var reticle: ColorRect = get_parent().get_node("ui/hud/reticle")

@onready var backpack: PackedScene = preload("res://prefabs/backpack.tscn")
@onready var pickup: PackedScene = preload("res://prefabs/pickup.tscn")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("mesh").visible = false

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	if Input.is_action_just_pressed("esc"):
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# send height to world for temperature calculation
	world.player_alt = position.y
	
	# movement direction
	var input_dir
	if !player_stats.energy <= 0:
		input_dir = Input.get_vector("mov_left", "mov_right", "mov_forward", "mov_backward")
	else:
		input_dir = Vector2(0, 0)
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# gravity
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	# handle death
	if player_stats.energy <= 0:
		col.shape.height = 0.1
		cam.rotation.z = lerp(cam.rotation.z, deg_to_rad(90), delta * 2.0)
		velocity.x = lerp(velocity.x, direction.x, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z, delta * 3.0)
		move_and_slide()
		return
		
	# coyote_time
	if is_on_floor() and !grounded:
		grounded = true
	elif grounded == true and coyote_timer.is_stopped():
		coyote_timer.start()

	# handle jump
	if Input.is_action_just_pressed("mov_jump") and is_on_floor() and player_stats.stamina >= (player_stats.STAMINA_DRAIN * 1.5):
		velocity.y = JUMP_VELOCITY
		player_stats.stamina -= player_stats.STAMINA_DRAIN * 1.5
		sfx.play_sfx(2)
		
	# handle crouch
	if Input.is_action_pressed("mov_crouch"):
		col.shape.height = lerp(col.shape.height, 0.5, delta * 4.0)
		crouched = true
	else:
		col.shape.height = lerp(col.shape.height, 1.8, delta * 3.0)
		crouched = false
		
	# handle move speed
	if crouched:
		speed = CROUCH_SPEED
	elif Input.is_action_pressed("mov_sprint") and player_stats.can_sprint and !crouched and player_stats.stamina > 0:
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	if player_stats.stamina <= 0:
		player_stats.can_sprint = false
		sprint_cooldown_timer.start()

	# movement
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)

	# head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	cam.transform.origin = _headbob(t_bob)
	
	# sfx
	if direction:
		if cos(t_bob * BOB_FREQ / 2) > 0.9 and !sfx.sfx_footstep_1.playing:
			if speed == SPRINT_SPEED:
				sfx.play_sfx(0, "sprint")
			else:
				sfx.play_sfx(0)
		if cos(t_bob * BOB_FREQ / 2) < -0.9 and !sfx.sfx_footstep_2.playing:
			if speed == SPRINT_SPEED:
				sfx.play_sfx(1, "sprint")
			else:
				sfx.play_sfx(1)

	# fov
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	if !mode_interact:
		cam.fov = lerp(cam.fov, target_fov, delta * 8.0)

	var was_on_floor = is_on_floor()
	move_and_slide()
	
	if is_on_floor() and not was_on_floor:
		sfx.play_sfx(3)
		
	
	# handle interaction
	if Input.is_action_pressed("mode_interact") and speed != SPRINT_SPEED:
		mode_interact = true
		ray_large.enabled = false
		ray_small.enabled = true
		reticle.visible = true
		cam.fov = lerp(cam.fov, ZOOM_FOV, delta * 8.0)
	else:
		mode_interact = false
		ray_large.enabled = true
		ray_small.enabled = false
		reticle.visible = false
	
	# normal mode
	if ray_large.is_colliding():
		var ray_col = ray_large.get_collider()
		
		if Input.is_action_just_pressed("act_backpack") and is_on_floor() and !placed_backpack:
			if ray_col.is_in_group("ground"):
				var inst_backpack: Node3D = backpack.instantiate()
				inst_backpack.position = ray_large.get_collision_point()
				inst_backpack.rotation = head.rotation
				inst_backpack.data = backpack_res
				get_parent().add_child(inst_backpack)
				placed_backpack = true
				backpack_res = empty_backpack
				
		if ray_col is LargeInteract:
			lab_prompt.text = "[F] " + ray_col.prompt_message
			lab_prompt.visible = true
			
			if Input.is_action_just_pressed("act_pickup"):
				if ray_col.type == "backpack":
					ray_col.use_backpack()
					print(backpack_res.main, backpack_res.top)
					placed_backpack = false
					lab_prompt.visible = false
					
	elif ray_large.enabled and !ray_large.is_colliding():
		lab_prompt.visible = false
	
	# interact mode
	if ray_small.is_colliding():
		var ray_col = ray_small.get_collider()
		
		if ray_col is SmallInteract:
			lab_prompt.visible = true
			lab_prompt.text = ray_col.prompt_message
			
			# handle backpack pockets
			if ray_col.type == "pocket":
				if !is_holding:
					if ray_col.contents == []:
						lab_prompt.text = "Container Empty"
					else:
						lab_prompt.text = "Extract from " + ray_col.section.capitalize()
						if Input.is_action_just_pressed("act_interact"):
							is_holding = true
							holding = ray_col.contents[0]
							ray_col.extract_item()
				else:
					if ray_col.whitelist == [] or ray_col.whitelist.has(holding.type):
						
						var current_capacity = ray_col.get_used_capacity()
						var added_capacity = holding.size + current_capacity
						if added_capacity <= ray_col.size:
							lab_prompt.text = "Pack " + holding.display_name + " into " + ray_col.section.capitalize()
							if Input.is_action_just_pressed("act_interact"):
								ray_col.insert_item(holding)
								holding = null
								is_holding = false
						else:
							lab_prompt.text = "Not enough space to pack " + holding.display_name + " into " + ray_col.section.capitalize()
					else:
						lab_prompt.text = "Cannot place " + holding.display_name + " into " + ray_col.section.capitalize()
						
		# handle pickup items
		if ray_col is Pickup:
			lab_prompt.visible = true
			lab_prompt.text = "Pick up " + ray_col.res.display_name
			
			if Input.is_action_just_pressed("act_interact"):
				is_holding = true
				holding = ray_col.res
				ray_col.pickup_item()
			
	elif ray_small.enabled and !ray_small.is_colliding():
		lab_prompt.visible = false
		
	if Input.is_action_just_pressed("act_drop") and is_holding:
		var inst_pickup: Pickup = pickup.instantiate()
		inst_pickup.res = holding
		inst_pickup.position = $head/drop_point.global_position
		inst_pickup.rotation = head.rotation
		is_holding = false
		holding = null
		get_parent().add_child(inst_pickup)
	
	if is_holding:
		lab_holding.text = "Holding " + holding.display_name
		lab_holding.visible = true
		$head/cam/item.visible = true
	else:
		lab_holding.visible = false
		$head/cam/item.visible = false
	
func _headbob(time: float) -> Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
func _on_coyote_time_timeout():
	grounded = false

func _on_sprint_cooldown_timeout():
	player_stats.can_sprint = true
