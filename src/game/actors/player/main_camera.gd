extends Camera3D

# Reference to the secondary camera used for rendering equippable items
@onready var equippable_item_camera: Camera3D = %EquippableItemCamera

func _process(_delta: float) -> void:
	# Sync the equippable item's camera position and rotation with the main camera
	equippable_item_camera.global_transform = global_transform
