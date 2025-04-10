extends Node

# Dictionary to store active bulletins, mapped by their keys
var bulletins := {}

# Called when the node enters the scene tree
func _enter_tree() -> void:
	# Connect event signals to their respective functions
	EventSystem.BUL_create_bulletin.connect(create_bulletin)
	EventSystem.BUL_distroy_bulletin.connect(distroy_bulletin)
	EventSystem.BUL_distroy_all_bulletins.connect(distroy_all_bulletins)

# Creates a bulletin instance and adds it to the scene
func create_bulletin(key: BulletinConfig.Keys, extra_arg = null) -> void:
	# Prevents duplicate bulletins of the same type
	if bulletins.has(key):
		return
	# Load and instantiate the bulletin scene
	var new_bulletin := BulletinConfig.get_bulletin(key)
	new_bulletin.initialize(extra_arg) # Pass any additional arguments if needed
	add_child(new_bulletin) # Add the bulletin to the scene tree
	bulletins[key] = new_bulletin # Store reference to the bulletin

# Destroys a specific bulletin
func distroy_bulletin(key: BulletinConfig.Keys) -> void:
	# Ensure the bulletin exists before attempting to remove it
	if not bulletins.has(key):
		return
	bulletins[key].queue_free() # Remove from the scene
	bulletins.erase(key) # Remove from the dictionary

# Destroys all bulletins currently active
func distroy_all_bulletins() -> void:
	# Iterate over all children and remove them
	for child in get_children():
		child.queue_free()
	bulletins.clear() # Clear the dictionary
