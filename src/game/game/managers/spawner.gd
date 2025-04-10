extends Node3D  # Extends Node3D, making this a spatial node in the scene

# Exposed variable to assign a node that will hold constructable objects
@export var constructable_holder: Node3D

# Reference to the "Items" child node, retrieved when the script initializes
@onready var items: Node3D = $Items

# Called when the node enters the scene tree
func _enter_tree() -> void:
	EventSystem.SPA_spawn_scene.connect(spawn_scene)  # Connects the spawn event to the spawn_scene function

# Spawns a scene at a given transform location
# - `scene`: The PackedScene to instantiate
# - `tform`: The Transform3D defining the position, rotation, and scale
# - `is_constructable`: Determines whether the object is a constructable or a loose item
func spawn_scene(scene: PackedScene, tform: Transform3D, is_constructable := false) -> void:
	var object := scene.instantiate()  # Creates an instance of the given scene
	object.global_transform = tform  # Sets its global position, rotation, and scale

	if is_constructable:
		# If the object is constructable, add it to the constructable holder
		constructable_holder.add_child(object)
		EventSystem.GAM_update_navmesh.emit()  # Triggers an update to the navigation mesh
	else:
		# Otherwise, add it to the "Items" node for loose objects
		items.add_child(object)
