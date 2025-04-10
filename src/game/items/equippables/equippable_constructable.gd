extends EquippableItem
class_name EquippableConstructable

# This script handles the placement and construction of objects in the game world.
# It ensures proper positioning, validates placement, and spawns the final constructed object.

# Preloads materials for valid and invalid placement previews
const VALID_MATERIAL : StandardMaterial3D = preload("res://resources/materials/constructable_valid_material.tres")
const INVALID_MATERIAL : StandardMaterial3D = preload("res://resources/materials/constructable_invalid_material.tres")

# References to scene nodes
@onready var item_place_ray: RayCast3D = $ItemPlaceRay  # Raycast to determine placement position
@onready var constructable_area: Area3D = $ConstructableArea  # Area used to check for obstacles
@onready var constructable_area_collision_shape: CollisionShape3D = $ConstructableArea/CollisionShape3D  # Collision shape for placement validation
@onready var constructable_preview_mesh: MeshInstance3D = $ConstructableArea/ConstructablePreviewMesh  # Visual preview of the constructable item

# Variables for construction logic
var constructable_item_key : ItemConfig.Keys  # Key identifying the constructable item
var obstacles : Array[Node3D] = []  # List of detected obstacles
var place_valid := false  # Whether the current placement location is valid
var is_constructing := false  # Whether the item is currently being placed

func _ready() -> void:
	# Initializes the construction preview
	constructable_area.rotation = Vector3.ZERO
	constructable_preview_mesh.mesh = $MeshHolder.get_child(0).mesh.duplicate()
	constructable_area_collision_shape.shape = constructable_preview_mesh.mesh.create_convex_shape()
	set_preview_material(INVALID_MATERIAL)  # Default to invalid material

# Sets the preview material to indicate whether placement is valid
func set_preview_material(material : StandardMaterial3D) -> void:
	for i in constructable_preview_mesh.mesh.get_surface_count():
		constructable_preview_mesh.set_surface_override_material(i, material)

func _process(_delta: float) -> void:
	# Updates the placement preview rotation and validity status each frame
	constructable_area.global_rotation.y = global_rotation.y + PI
	set_valid(check_build_validity())

# Updates the placement validity and changes the preview material accordingly
func set_valid(valid : bool) -> void:
	if place_valid == valid:
		return
	set_preview_material(VALID_MATERIAL if valid else INVALID_MATERIAL)
	place_valid = valid

# Checks whether the current build location is valid
func check_build_validity() -> bool:
	if item_place_ray.is_colliding():
		constructable_area.global_position = item_place_ray.get_collision_point()
		return obstacles.is_empty()  # Placement is valid if no obstacles are detected
	constructable_area.global_position = item_place_ray.to_global(item_place_ray.target_position)
	return false

# Attempts to construct the object at the valid placement position
func try_to_construct() -> void:
	if not place_valid:
		return
	EventSystem.EQU_delete_equipped_item.emit()  # Remove equipped construction item
	constructable_area.hide()  # Hide the placement preview
	set_process(false)  # Stop processing placement updates
	EventSystem.SPA_spawn_scene.emit(
		ItemConfig.get_constructable_item(constructable_item_key),
		constructable_area.global_transform,
		true
	)
	if constructable_item_key == ItemConfig.Keys.Campfire:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.BuildCampfire)
	elif constructable_item_key == ItemConfig.Keys.Tent:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.BuildTent)
	elif constructable_item_key == ItemConfig.Keys.Raft:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.BuildRaft)
	is_constructing = true
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.Build)  # Play build sound effect

# Destroys the construction preview if the item is being placed
func destroy_self() -> void:
	if not is_constructing:
		return
	EventSystem.EQU_unequip_item.emit()

# Detects when a body enters the constructable area, marking it as an obstacle
func _on_constructable_area_body_entered(body: Node3D) -> void:
	obstacles.append(body)

# Detects when a body exits the constructable area, removing it from the obstacle list
func _on_constructable_area_body_exited(body: Node3D) -> void:
	obstacles.erase(body)
