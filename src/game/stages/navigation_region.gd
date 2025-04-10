extends NavigationRegion3D  # This script extends NavigationRegion3D, making this node a navigation region in 3D space.

# Called when the node enters the scene tree.
func _enter_tree() -> void:
	# Connects the bake_navigation_mesh function to the GAM_update_navmesh signal from EventSystem.
	# This means whenever the GAM_update_navmesh signal is emitted, the navigation mesh will be baked (updated).
	EventSystem.GAM_update_navmesh.connect(bake_navigation_mesh)
