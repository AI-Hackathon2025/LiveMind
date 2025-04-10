extends Node3D
class_name EquippableItem

# Base class for equippable items (e.g., weapons, tools, consumables).
# Handles animations and visibility layers.

@onready var animation_player: AnimationPlayer = $AnimationPlayer  # Reference to the animation player

func _ready() -> void:
	# Set rendering layers for all visual components of the item.
	# This ensures that the item is only visible in the correct layer (e.g., player hands).
	for child in $MeshHolder.get_children():
		if child is VisualInstance3D:
			child.layers = 2  # Assigns the item to a specific rendering layer

func try_to_use() -> void:
	# Plays the "use_item" animation if no other animation is playing
	if animation_player.is_playing():
		return
	animation_player.play("use_item")
