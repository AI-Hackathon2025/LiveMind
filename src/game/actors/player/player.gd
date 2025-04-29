extends CharacterBody3D  # This script extends CharacterBody3D, making it a controllable player character.

# Movement and gameplay settings
@export var normal_speed := 3.0  # Walking speed
@export var sprint_speed := 6.0  # Sprinting speed
@export var jump_velocity := 4.0  # Jump force
@export var gravity := 0.2  # Gravity force applied to the player
@export var mouse_sensitivity := 0.002  # Sensitivity for mouse movement
@export var sprinting_energy_change_per_1m := -1.0  # Energy cost per meter when sprinting
@export var energy_regen_per_tick := 0.5  # Energy regeneration per game tick
@export var walking_footstep_audio_interval := 0.6  # Interval between footstep sounds when walking
@export var sprinting_footstep_audio_interval := 0.3  # Interval between footstep sounds when sprinting

# Node references
@onready var head: Node3D = $Head  # Reference to the player's head node
@onready var interaction_ray_cast: RayCast3D = $Head/InteractionRayCast  # Raycast for detecting interactions
@onready var equippable_item_holder: Node3D = %EquippableItemHolder  # Reference to item holder for equippable items
@onready var footstep_audio_timer: Timer = $FootstepAudioTimer  # Timer for footstep sounds

# Player state variables
var is_grounded := true  # Tracks whether the player is on the ground
var is_sprinting := false  # Tracks whether the player is sprinting

# Called when the node enters the scene tree
func _enter_tree() -> void:
	# Connects freeze and unfreeze signals to set_freeze function
	EventSystem.PLA_freeze_player.connect(set_freeze.bind(true))
	EventSystem.PLA_unfreeze_player.connect(set_freeze.bind(false))

# Called when the node is ready
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Locks the mouse to the center of the screen
	EventSystem.HUD_show_hud.emit()  # Emits signal to show HUD

# Called when the node exits the scene tree
func _exit_tree() -> void:
	EventSystem.HUD_hide_hud.emit()  # Emits signal to hide HUD

# Freezes or unfreezes player movement and input handling
func set_freeze(freeze: bool) -> void:
	set_process(!freeze)  # Enables/disables the processing of _process
	set_physics_process(!freeze)  # Enables/disables physics processing
	set_process_input(!freeze)  # Enables/disables input processing
	set_process_unhandled_key_input(!freeze)  # Enables/disables unhandled key input processing

# Called every frame to handle non-physics updates
func _process(delta: float) -> void:
	interaction_ray_cast.check_interaction()  # Checks for interactable objects
	check_energy_change(delta)  # Updates player's energy levels

# Called every physics frame to handle movement and physics-based interactions
func _physics_process(delta: float) -> void:
	move()  # Handles movement
	check_energy_change(delta)  # Updates energy again for physics-based movement

	# Checks if the player is using an item
	if Input.is_action_just_pressed("use_item"):
		equippable_item_holder.try_to_use_item()

# Handles movement, jumping, and footstep sounds
func move() -> void:
	# Check if the player is on the floor
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")  # Check if sprint key is pressed
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity  # Apply jump force

		# Play footstep sounds when moving
		if velocity != Vector3.ZERO and footstep_audio_timer.is_stopped():
			EventSystem.SFX_play_dynamic_sfx.emit(SFXConfig.Keys.Footstep, global_position, 0.3)
			footstep_audio_timer.start(walking_footstep_audio_interval if not is_sprinting else sprinting_footstep_audio_interval)

		# Detect landing from a jump
		if not is_grounded:
			is_grounded = true
			EventSystem.SFX_play_dynamic_sfx.emit(SFXConfig.Keys.JumpLand, global_position)
	else:
		# Apply gravity when in the air
		velocity.y -= gravity
		if is_grounded:
			is_grounded = false

	# Determine speed based on sprinting state
	var speed := normal_speed if not is_sprinting else sprint_speed
	
	# Get movement direction from input
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := transform.basis * Vector3(input_dir.x, 0, input_dir.y)

	# Apply movement velocity
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	move_and_slide()  # Moves the character while handling collisions

# Handles energy depletion when sprinting and regeneration when not
func check_energy_change(delta: float) -> void:
	var movement_magnitude := Vector2(velocity.x, velocity.z).length()

	# If the player is moving and sprinting, drain energy
	if movement_magnitude > 0 and is_sprinting:
		EventSystem.PLA_change_energy.emit(
			delta * sprinting_energy_change_per_1m * movement_magnitude
		)
	else:
		# Otherwise, regenerate energy over time
		EventSystem.PLA_change_energy.emit(delta * energy_regen_per_tick)

# Handles mouse movement input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_around(event.relative)

# Rotates the player and camera based on mouse movement
func look_around(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)  # Rotate player body left/right
	head.rotate_x(-relative.y * mouse_sensitivity)  # Rotate camera up/down
	head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90)  # Clamp vertical look angle

# Handles keyboard input for opening menus and using hotkeys
func _unhandled_key_input(event: InputEvent) -> void:
	# Opens the pause menu when "ui_cancel" is pressed
	if event.is_action_pressed("ui_cancel"):
		ChatManager.instance.hide_ai_prompt()
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PauseMenu)
		set_freeze(true)

	# Opens the crafting menu when "open_crafting_menu" is pressed
	elif event.is_action_pressed("open_crafting_menu"):
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.OpenInventory)

	# Handles hotkey input for equipping items
	elif event.is_action_pressed("item_hotkey"):
		EventSystem.EQU_hotkey_pressed.emit(int(event.as_text()))
