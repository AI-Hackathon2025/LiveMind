extends CharacterBody3D

# Constants for animation blending time and gravity force
const ANIM_BLEND = 0.2
const GRAVITY = 2.0

# Enum representing different states of the character
enum States {
	Idle,
	Wander,
	Dead,
	Flee,
	Hurt,
	Chase,
	Attack
}

# Initial state is Idle
var state := States.Idle
var player_in_vision_range := false

# Timers for different behaviors
@onready var idle_timer: Timer = %IdleTimer
@onready var wander_timer: Timer = %WanderTimer
@onready var disappear_after_death_timer: Timer = %DisappearAfterDeathTimer
@onready var flee_timer: Timer = $Timers/FleeTimer

# References to other game objects and components
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var meat_spawn_marker: Marker3D = $MeatSpawnMarker
@onready var eyes_marker: Marker3D = $EyesMarker
@onready var attack_hit_area: Area3D = $AttackHitArea
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player : AnimationPlayer = %AnimationPlayer
@onready var vision_area_collision_shape: CollisionShape3D = $VisionArea/CollisionShape3D

# Health-related variable
@onready var health := max_health

# Exported variables for tweaking behavior
@export var normal_speed := 0.6
@export var alarmed_speed := 1.8
@export var max_health := 80.0
@export var idle_animations : Array[String] = []
@export var hurt_animations : Array[String] = []
@export var turn_speed_weight := 0.87
@export var min_idle_time := 2.0
@export var max_idle_time := 7.0
@export var min_wander_time := 2.0
@export var max_wander_time := 4.0
@export var flee_timer_length := 3.0
@export var is_aggresive := false
@export var attacki_distance := 2.0
@export var damage := 20.0
@export var vision_range := 15.0
@export var vision_fov := 80.0
@export var attack_audio_key := SFXConfig.Keys.WolfAttack

func _ready() -> void:
	# Connects animation finished event to its handler
	animation_player.animation_finished.connect(animation_finished)
	# Sets vision area radius based on vision_range variable
	vision_area_collision_shape.shape.radius = vision_range
	
func animation_finished(_anim_name : String) -> void:
	# Handles different state transitions after animations
	if state == States.Idle:
		animation_player.play(idle_animations.pick_random(), ANIM_BLEND) 
	elif state == States.Hurt:
		if not is_aggresive:
			set_state(States.Flee)
		else:
			set_state(States.Chase)
	if state == States.Attack:
		set_state(States.Chase)

func _physics_process(_delta: float) -> void:
	# Main state machine controlling character behavior
	if state == States.Idle:
		idle_loop()
	elif state == States.Wander:
		wander_loop()
	elif state == States.Flee:
		flee_loop()
	elif state == States.Chase:
		chase_loop()
	elif state == States.Attack:
		attack_loop()

func idle_loop() -> void:
	# Handles idle behavior
	apply_gravity()
	if is_aggresive and can_see_player():
		set_state(States.Chase)

func wander_loop() -> void:
	# Handles wandering movement
	look_forward()
	apply_gravity()
	move_and_slide()
	if is_aggresive and can_see_player():
		set_state(States.Chase)

func flee_loop() -> void:
	# Handles fleeing movement
	look_forward()
	apply_gravity()
	move_and_slide()

func chase_loop() -> void:
	# Handles chasing movement
	if not can_see_player():
		set_state(States.Wander)
	look_forward()
	if global_position.distance_to(player.global_position) < attacki_distance:
		set_state(States.Attack)
		return
	nav_agent.target_position = player.global_position
	var dir := global_position.direction_to(nav_agent.get_next_path_position())
	dir.y = 0
	velocity.x = dir.normalized().x * alarmed_speed
	velocity.z = dir.normalized().z * alarmed_speed
	apply_gravity()
	move_and_slide()

func attack_loop() -> void:
	# Handles attack rotation
	var dir := global_position.direction_to(player.global_position)
	rotation.y = lerp_angle(rotation.y,  atan2(dir.x, dir.z) + PI, turn_speed_weight)

func apply_gravity() -> void:
	# Applies gravity if not on the floor
	if not is_on_floor():
		velocity.y -= GRAVITY
	else:
		velocity.y = 0

func attack() -> void:
	# Handles attack logic
	if player in attack_hit_area.get_overlapping_bodies():
		EventSystem.PLA_change_health.emit(-damage)

func look_forward() -> void:
	# Smoothly rotates towards movement direction
	rotation.y = lerp_angle(rotation.y,  atan2(velocity.x, velocity.z) + PI, turn_speed_weight)

func pick_wander_velocity() -> void:
	# Select the wander velocity
	var dir := Vector2(0, -1).rotated(randf() * PI * 2)
	velocity = Vector3(dir.x, 0, dir.y) * normal_speed

func can_see_player() -> bool:
	# Checks if the player is visible
	return player_in_vision_range and player_in_fov() and player_in_los()

func player_in_fov() -> bool:
	# Checks if the player is within field of view
	if not player:
		return false
	var direction_to_player := global_position.direction_to(player.global_position)
	var forward := -global_transform.basis.z
	return direction_to_player.angle_to(forward) <= deg_to_rad(vision_fov)

func player_in_los() -> bool:
	# Performs a raycast to check line of sight
	if not player:
		return false
	var query_params := PhysicsRayQueryParameters3D.new()
	query_params.from = eyes_marker.global_position
	query_params.to = player.head.global_position + Vector3(0, 1.5, 0)
	query_params.collision_mask = 1 + 64
	var space_state := get_world_3d().direct_space_state
	var result := space_state.intersect_ray(query_params)
	return result.is_empty()

func _on_idle_timer_timeout() -> void:
	set_state(States.Wander)

func _on_wander_timer_timeout() -> void:
	set_state(States.Idle)

func _on_disappear_after_death_timer_timeout() -> void:
	queue_free()

func _on_flee_timer_timeout() -> void:
	set_state(States.Idle)

func pick_away_from_player_velocity() -> void:
	if not player:
		set_state(States.Idle)
		return
	var dir := player.global_position.direction_to(global_position)
	dir.y = 0
	velocity = dir.normalized() * alarmed_speed

func set_state(new_state : States) -> void:
	# Sets the character's state and triggers necessary animations or behaviors
	state = new_state
	match state:
		States.Idle:
			idle_timer.start(randf_range(min_idle_time, max_idle_time))
			animation_player.play(idle_animations.pick_random(), ANIM_BLEND)
		States.Wander:
			pick_wander_velocity()
			wander_timer.start(randf_range(min_wander_time, max_wander_time))
			animation_player.play("Walk", ANIM_BLEND)
		States.Hurt:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play(hurt_animations.pick_random(), ANIM_BLEND)
		States.Flee:
			pick_away_from_player_velocity()
			animation_player.play("Gallop", ANIM_BLEND)
			flee_timer.start(flee_timer_length)
		States.Chase:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play("Gallop", ANIM_BLEND)
		States.Attack:
			animation_player.play("Attack", ANIM_BLEND)
		States.Dead:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			main_collision_shape.disabled = true
			animation_player.play("Death", ANIM_BLEND)
			var meat_scene := ItemConfig.get_pickuppable_item(ItemConfig.Keys.RawMeat)
			EventSystem.SPA_spawn_scene.emit(meat_scene, meat_spawn_marker.global_transform)
			EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.HuntAnimal)
			set_physics_process(false)
			disappear_after_death_timer.start(10)

func play_attack_audio() -> void:
	EventSystem.SFX_play_dynamic_sfx.emit(attack_audio_key, global_position)

func take_hit(weapon_item_resource : WeaponItemResource) -> void:
	health -= weapon_item_resource.damage
	if state != States.Dead and health <= 0:
		set_state(States.Dead)
	elif not state in [States.Flee, States.Dead]:
		set_state(States.Hurt)

func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = true

func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = false
