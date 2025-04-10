extends InventorySlot
class_name FinalCookingSlot

signal cooked_food_taken  # Emitted when the cooked food is removed from the slot

# Prevents dragging and dropping items into this slot
func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	return false
