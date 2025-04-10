extends Interactable  # This script extends Interactable, making it an object that can be interacted with.
class_name Pickuppable  # Defines a class name for easier reference in Godot.

# Exported variable to define the item key, which links to an item in the ItemConfig.
@export var item_key : ItemConfig.Keys

# Reference to the parent node (the object that holds this script).
@onready var parent : Node3D = get_parent()

# Function called when the player interacts with this object.
func start_interaction() -> void:
	# Emits a signal to try picking up the item, passing the item key and a function to destroy the item upon success.
	EventSystem.INV_try_to_pickup_item.emit(item_key, distroy_self)
	if item_key == ItemConfig.Keys.Fruit:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.GatherFruit)
	else : 
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.GatherItems)

# Function to destroy the object once it's picked up.
func distroy_self() -> void:
	# Emits a signal to play the item pickup sound effect.
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.ItemPickup)
	# Removes the parent node (effectively removing the item from the scene).
	parent.queue_free()
