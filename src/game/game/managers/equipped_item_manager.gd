extends Node

var active_hotbar_slot  # Stores the currently selected hotbar slot index
var hotbar : Array  # Stores the items in the hotbar

func _enter_tree() -> void:
	# Connects to event signals for hotbar updates, hotkey presses, and item deletion
	EventSystem.INV_hotbar_updated.connect(hotbar_updated)
	EventSystem.EQU_hotkey_pressed.connect(hotkey_pressed)
	EventSystem.EQU_delete_equipped_item.connect(delete_equipped_item)
	
func _ready() -> void:
	# Emits an event that no hotbar slot is currently active
	EventSystem.EQU_active_hotbar_slot_updated.emit(null)

func hotbar_updated(_hotbar : Array) -> void:
	# Updates the hotbar array when it changes
	hotbar = _hotbar
	# If the currently active slot is empty, unequip the item and reset active slot
	if active_hotbar_slot != null and hotbar[active_hotbar_slot] == null:
		EventSystem.EQU_unequip_item.emit()
		active_hotbar_slot = null
		EventSystem.EQU_active_hotbar_slot_updated.emit(null)
	
func hotkey_pressed(hotkey : int) -> void:
	var idx := hotkey - 1  # Convert hotkey to zero-based index
	
	# Check if the index is valid and if there's an item in the slot
	if idx < 0 or idx >= hotbar.size():
		return  
	if hotbar[idx] == null:
		return
	
	if idx != active_hotbar_slot:
		# If pressing a different slot, equip the new item
		active_hotbar_slot = idx
		EventSystem.EQU_equip_item.emit(hotbar[idx])
		EventSystem.EQU_active_hotbar_slot_updated.emit(idx)
	else:
		# If pressing the same slot again, unequip the item
		active_hotbar_slot = null
		EventSystem.EQU_unequip_item.emit()
		EventSystem.EQU_active_hotbar_slot_updated.emit(null)

func delete_equipped_item() -> void:
	# Deletes the currently equipped item from the hotbar and resets active slot
	EventSystem.INV_delete_item_by_index.emit(active_hotbar_slot, true)
	EventSystem.EQU_active_hotbar_slot_updated.emit(null)
	active_hotbar_slot = null
