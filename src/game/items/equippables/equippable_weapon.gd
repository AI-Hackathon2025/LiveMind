extends EquippableItem
class_name EquippableWeapon

@onready var hit_check_marker: Marker3D = $HitCheckMarker

var weapon_item_resource : WeaponItemResource  # Stores weapon properties like range and damage

func _ready() -> void:
	# Sets the hit detection marker position based on the weapon's range
	hit_check_marker.position.z = -weapon_item_resource.range
	super()  # Calls the parent class's _ready() function

func change_energy() -> void:
	# Reduces the player's energy when using the weapon
	EventSystem.PLA_change_energy.emit(weapon_item_resource.energy_change_per_use)

func check_hit() -> void:
	# Performs a raycast to check if the weapon hits an enemy
	
	var space_state := get_world_3d().direct_space_state
	var ray_query_params := PhysicsRayQueryParameters3D.new()
	
	# Raycast settings
	ray_query_params.collide_with_areas = true  # Only detect areas (e.g., enemy hitboxes)
	ray_query_params.collide_with_bodies = false  # Ignore physical objects like walls
	ray_query_params.collision_mask = 8  # Layer 8 is used for hitboxes
	ray_query_params.from = global_position  # Start from weapon position
	ray_query_params.to = hit_check_marker.global_position  # End at the weapon's max range
	
	# Perform raycast
	var result := space_state.intersect_ray(ray_query_params)
	
	if not result.is_empty():
		# If an object is hit, call its take_hit function and pass weapon stats
		result.collider.take_hit(weapon_item_resource)

func play_swoosh_audio() -> void:
	# Plays a sound effect for the weapon swing
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.WeaponSwoosh)
