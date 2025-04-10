extends Node3D

# Object attributes containing health, weapon filter, and drop item key
@export var attributes : HittableObjectAttributes

# Optional static body to leave behind after destruction (e.g., a stump for a tree)
@export var residue_static_body : StaticBody3D

# Reference point for spawning dropped items
@onready var item_spawn_point: Node3D = $ItemSpawnPoint

# Current health of the object
var current_heath : float

func _ready() -> void:
	# Initialize health if attributes are assigned
	if attributes:
		current_heath = attributes.max_health

	# Remove the residue static body from the scene until needed
	if residue_static_body != null:
		remove_child(residue_static_body)

# Called when the object is hit
func register_hit(weapon_item_resource: WeaponItemResource) -> void:
	# If a weapon filter exists and the weapon used isn't in it, ignore the hit
	if not attributes.weapon_filter.is_empty() and not weapon_item_resource.item_key in attributes.weapon_filter:
		return

	# Reduce health based on weapon damage
	current_heath -= weapon_item_resource.damage
	
	# If health reaches zero, destroy the object
	if current_heath <= 0:
		die()
		
# Handles object destruction
func die() -> void:
	# Spawn the configured item drop at each marker position
	var scene_to_spawn = ItemConfig.get_pickuppable_item(attributes.drop_item_key)
	for marker in item_spawn_point.get_children():
		EventSystem.SPA_spawn_scene.emit(scene_to_spawn, marker.global_transform)

	# Complete Quests
	if attributes.drop_item_key == ItemConfig.Keys.Log:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.ChopTree)
	else :
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.MineSomething)
		
	# If there is no residue body, remove the object entirely
	if residue_static_body == null:
		queue_free()
		return

	# Clear all children (e.g., visual elements) before replacing with residue
	for child in get_children():
		child.queue_free()
	
	# Add the residue body as a child, replacing the original object
	add_child(residue_static_body)
	
