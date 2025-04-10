extends TextureRect
class_name InventorySlot  # Represents a slot in the inventory or hotbar

@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect  # Reference to the UI element displaying the item icon

var item_key  # Stores the key of the item in this slot

# Sets the item in the slot and updates its icon
func set_item_key(_item_key) -> void:
	item_key = _item_key
	update_icon()

# Updates the icon displayed in the slot based on the item key
func update_icon() -> void:
	if item_key == null:
		icon_texture_rect.texture = null  # Clear the icon if the slot is empty
		return
	
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon  # Set the item icon

# Handles drag-and-drop behavior when dragging an item from the slot
func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_key != null:
		var drag_preview := TextureRect.new()
		drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		drag_preview.texture = icon_texture_rect.texture
		drag_preview.custom_minimum_size = Vector2(80, 80)
		drag_preview.modulate = Color(1, 1, 1, 0.7)  # Semi-transparent drag preview
		set_drag_preview(drag_preview)
		EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)  # Play UI click sound
		return self
	return null  # If no item, nothing to drag

# Determines if an item can be dropped into this slot
func _can_drop_data(_at_position: Vector2, slot: Variant) -> bool:
	if item_key != null:  # If this slot already has an item
		if slot is HotbarSlot:
			return ItemConfig.get_item_resource(item_key).is_eqippable  # Only equipable items can go to the hotbar
		if slot is StartingCookingSlot:
			return ItemConfig.get_item_resource(item_key).cooking_recipe != null  # Only items with a cooking recipe can go into the cooking slot
		if slot is FinalCookingSlot:
			return false  # Cooked items cannot be placed back into a final cooking slot
	return slot is InventorySlot  # Otherwise, it can be swapped with another inventory slot

# Handles dropping an item into this slot
func _drop_data(_at_position: Vector2, old_slot: Variant) -> void:
	if old_slot is StartingCookingSlot:
		# Swap item with a cooking slot and disable ingredient input
		var temp_own_key = item_key
		EventSystem.INV_add_item_by_index.emit(old_slot.item_key, get_index(), self is HotbarSlot)
		old_slot.set_item_key(temp_own_key)
		old_slot.starting_ingrediant_disabled.emit()
	elif old_slot is FinalCookingSlot:
		# Move the cooked item into the inventory and clear the cooking slot
		EventSystem.INV_add_item_by_index.emit(old_slot.item_key, get_index(), self is HotbarSlot)
		old_slot.set_item_key(null)
		old_slot.cooked_food_taken.emit()
	else:
		# Swap items between two inventory or hotbar slots
		EventSystem.INV_switch_two_item_indexes.emit(
			old_slot.get_index(),
			old_slot is HotbarSlot,
			get_index(),
			self is HotbarSlot
		)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)  # Play UI click sound
