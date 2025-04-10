# This script defines a specialized inventory slot for starting the cooking process.
# It extends the InventorySlot class, adding functionality specific to cooking mechanics.

extends InventorySlot
class_name StartingCookingSlot

# Signals to notify when an ingredient is placed or removed
signal starting_ingrediant_enabled
signal starting_ingrediant_disabled

# Boolean flag to track if cooking is currently in progress
var cooking_in_progress := false

# Handles drag-and-drop interactions, preventing items from being dragged if cooking is active
func _get_drag_data(_at_position: Vector2):
	if cooking_in_progress:
		return null  # If cooking is in progress, prevent dragging the item out of the slot
	super(_at_position)  # Otherwise, call the parent function to allow normal behavior

# Determines if an item can be dropped into this slot
func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	if item_key != null:
		return false  # Prevents replacing an existing item in the slot
	if ItemConfig.get_item_resource(slot.item_key).cooking_recipe == null:
		return false  # Ensures the item has a valid cooking recipe before allowing placement
	return slot is InventorySlot  # Only allow items from inventory slots to be dropped

# Handles the logic when an item is dropped into the slot
func _drop_data(_at_position: Vector2, old_slot: Variant) -> void:
	set_item_key(old_slot.item_key)  # Assigns the item to this slot
	EventSystem.INV_delete_item_by_index.emit(old_slot.get_index(), old_slot is HotbarSlot)  
	# Removes the item from its previous slot (inventory or hotbar)
	
	starting_ingrediant_enabled.emit()  # Signals that a new cooking ingredient has been placed
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)  # Plays a UI click sound for feedback
