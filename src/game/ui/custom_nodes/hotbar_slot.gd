extends InventorySlot
class_name HotbarSlot

# Colors for active and inactive hotbar slots
const ACTIVE_COLOR = Color.WHITE
const UNACTIVE_COLOR = Color(0.8, 0.8, 0.8, 0.6)

func _ready() -> void:
	# Set the hotbar slot number text (1-based index)
	$NumTextureRect/NumLabel.text = str(get_index() + 1)

func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	# Ensure the dragged item is an InventorySlot
	if not slot is InventorySlot:
		return false
	# Allow dropping only if the item is equippable
	return ItemConfig.get_item_resource(slot.item_key).is_eqippable

func set_highlighted(enabled : bool) -> void:
	# Change slot color based on whether it's highlighted or not
	modulate = UNACTIVE_COLOR if not enabled else ACTIVE_COLOR
