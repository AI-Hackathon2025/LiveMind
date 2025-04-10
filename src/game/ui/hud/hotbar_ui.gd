extends HBoxContainer

func _enter_tree() -> void:
	# Connect to events related to the hotbar and equipped items
	EventSystem.INV_hotbar_updated.connect(update_hotbar)
	EventSystem.EQU_active_hotbar_slot_updated.connect(update_active_slot)
	# Ensure the active slot is updated when an item is unequipped
	EventSystem.EQU_unequip_item.connect(update_active_slot.bind(null))

func update_hotbar(hotbar : Array) -> void:
	# Update each hotbar slot with the corresponding item key from the hotbar array
	for slot in get_children():
		slot.set_item_key(hotbar[slot.get_index()]) 

func update_active_slot(slot_idx) -> void:
	# Highlight the currently active hotbar slot
	for slot in get_children():
		slot.set_highlighted(slot.get_index() == slot_idx)
