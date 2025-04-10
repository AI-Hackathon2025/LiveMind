extends Bulletin  # Extends Bulletin, making this script a base class for player menu-related UI.
class_name PlayerMenuBase  # Defines a class name for better reference in Godot.

# References to UI elements
@onready var inventory_container: GridContainer = %InventoryContainer  # Container holding inventory slots.
@onready var item_description_label: Label = %ItemDescriptionLabel  # Label for displaying item descriptions.
@onready var item_extra_info_label: Label = %ItemExtraInfoLabel  # Label for displaying additional item info.

# Called when the node enters the scene tree
func _enter_tree() -> void:
	# Connects to the inventory update signal, so the menu updates when inventory changes.
	EventSystem.INV_inventory_updated.connect(update_inventory)

# Called when the node is ready
func _ready() -> void:
	# Freezes the player to prevent movement while the menu is open.
	EventSystem.PLA_freeze_player.emit()
	# Makes the mouse visible for interacting with the UI.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Requests an inventory update to display the current inventory.
	EventSystem.INV_ask_update_inventory.emit()

	# Connects inventory slot interactions to display item information when hovered.
	for inventory_slot in inventory_container.get_children():
		inventory_slot.mouse_entered.connect(show_item_info.bind(inventory_slot))
		inventory_slot.mouse_exited.connect(hide_item_info)

	# Connects hotbar slot interactions to display item information when hovered.
	for hot_bar_slot in get_tree().get_nodes_in_group("HotbarSlots"):
		hot_bar_slot.mouse_entered.connect(show_item_info.bind(hot_bar_slot))
		hot_bar_slot.mouse_exited.connect(hide_item_info)

	# Plays a UI click sound when opening the menu.
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)
	# Hides the interaction prompt while the menu is open.
	EventSystem.UI_hide_interaction_propmt.emit()
	# Hides quests while the menu is open.
	EventSystem.QU_hide_quests.emit()

# Closes the menu and restores player controls
func close() -> void:
	# Shows the interaction prompt again after closing the menu.
	EventSystem.UI_show_interaction_propmt.emit()
	# Shows quests again after closing the menu.
	EventSystem.QU_show_quests.emit()
	# Locks the mouse back to the center for gameplay.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Emits signal to destroy the player menu bulletin.
	EventSystem.BUL_distroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	# Unfreezes the player so they can move again.
	EventSystem.PLA_unfreeze_player.emit()
	# Plays a UI click sound when closing the menu.
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)

# Displays item information when hovering over an inventory slot
func show_item_info(inventory_slot: InventorySlot) -> void:
	var item_key = inventory_slot.item_key
	# If the left mouse button is pressed or the slot is empty, do nothing.
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or item_key == null:
		return
	# Retrieves item data and updates the description label.
	var item_resource := ItemConfig.get_item_resource(item_key)
	item_description_label.text = item_resource.display_name + "\n" + item_resource.description

# Hides item information when the mouse leaves a slot
func hide_item_info() -> void:
	# If the left mouse button is pressed, do nothing to avoid flickering.
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	# Clears the item description label.
	item_description_label.text = ""

# Updates inventory UI based on the latest inventory data
func update_inventory(inventory: Array) -> void:
	for i in inventory.size():
		# Updates each slot in the inventory container with the corresponding item.
		inventory_container.get_child(i).set_item_key(inventory[i])
