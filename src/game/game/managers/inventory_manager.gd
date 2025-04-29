extends Node  # This script manages the player's inventory and hotbar.

# Constants defining the size of the inventory and hotbar
const INVENTORY_SIZE = 60
const HOTBAR_SIZE = 9

# Arrays representing the player's inventory and hotbar
var inventory : Array = []
var hotbar : Array = []

# Connect inventory-related signals when the node enters the tree
func _enter_tree() -> void:
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.INV_ask_update_inventory.connect(send_inventory)
	EventSystem.INV_switch_two_item_indexes.connect(switch_two_item_indexes)
	EventSystem.INV_add_item.connect(add_item)
	EventSystem.INV_delete_crafting_blueprint_cost.connect(delete_crafting_blueprint_cost)
	EventSystem.INV_delete_item_by_index.connect(delete_item_by_index)
	EventSystem.INV_add_item_by_index.connect(add_item_by_index)

# Initialize the inventory and hotbar sizes
func _ready() -> void:
	inventory.resize(INVENTORY_SIZE)
	hotbar.resize(HOTBAR_SIZE)
	
	## TEMPORARY: Pre-filling inventory with items for testing
	#inventory[0] = ItemConfig.Keys.Axe
	#inventory[1] = ItemConfig.Keys.Pickaxe
	#inventory[2] = ItemConfig.Keys.Tent
	#inventory[3] = ItemConfig.Keys.Campfire
	#inventory[4] = ItemConfig.Keys.RawMeat
	#inventory[5] = ItemConfig.Keys.Tinderbox
	#inventory[6] = ItemConfig.Keys.Multitool
	#inventory[7] = ItemConfig.Keys.Rope
	#inventory[8] = ItemConfig.Keys.Stick
	#inventory[9] = ItemConfig.Keys.Rope
	#inventory[10] = ItemConfig.Keys.Raft
	#inventory[11] = ItemConfig.Keys.Stick
	#inventory[12] = ItemConfig.Keys.Stick
	#inventory[13] = ItemConfig.Keys.Stick
	#inventory[14] = ItemConfig.Keys.Stick
	#inventory[15] = ItemConfig.Keys.Stick
	#inventory[16] = ItemConfig.Keys.Stick
	#inventory[17] = ItemConfig.Keys.Stick
	#inventory[18] = ItemConfig.Keys.Stick
	#inventory[19] = ItemConfig.Keys.Stone
	#inventory[20] = ItemConfig.Keys.Stick
	#inventory[21] = ItemConfig.Keys.Stick
	#inventory[22] = ItemConfig.Keys.Stick
	#inventory[23] = ItemConfig.Keys.Stone
	#inventory[24] = ItemConfig.Keys.Stone
	#inventory[25] = ItemConfig.Keys.Stone
	#inventory[26] = ItemConfig.Keys.Stone
	#inventory[27] = ItemConfig.Keys.Stone
	#inventory[28] = ItemConfig.Keys.Stone
	#inventory[29] = ItemConfig.Keys.Plant
	#inventory[30] = ItemConfig.Keys.Plant
	#inventory[31] = ItemConfig.Keys.Plant
	#inventory[32] = ItemConfig.Keys.Plant
	#inventory[33] = ItemConfig.Keys.Plant
	#inventory[34] = ItemConfig.Keys.Plant
	#inventory[35] = ItemConfig.Keys.Plant
	#inventory[36] = ItemConfig.Keys.Plant
	#inventory[37] = ItemConfig.Keys.Plant
	#inventory[38] = ItemConfig.Keys.Plant
	#inventory[39] = ItemConfig.Keys.Plant
	#
	#print("Inventory: ", inventory)


# Notify the system that the inventory has been updated
func send_inventory() -> void:
	EventSystem.INV_inventory_updated.emit(inventory)

# Notify the system that the hotbar has been updated
func send_hotbar() -> void:
	EventSystem.INV_hotbar_updated.emit(hotbar)

# Attempt to pick up an item, placing it in the inventory if space is available
func try_to_pickup_item(item_key: ItemConfig.Keys, destroy_pickuppable: Callable) -> void:
	if not get_free_slots():  # If no free slots, do nothing
		return
	
	add_item(item_key)  # Add the item to the inventory
	destroy_pickuppable.call()  # Remove the physical item from the world

# Get the number of empty slots available in the inventory
func get_free_slots() -> int:
	return inventory.count(null)

# Add an item to the first available slot in the inventory
func add_item(item_key: ItemConfig.Keys) -> void:
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item_key
			break
	send_inventory()  # Notify the system that the inventory has changed

# Swap two item positions, considering whether they are in the inventory or hotbar
func switch_two_item_indexes(idx1: int, idx1_is_in_hotbar: bool, idx2: int, idx2_is_in_hotbar: bool) -> void:
	var item1 = inventory[idx1] if not idx1_is_in_hotbar else hotbar[idx1]
	var item2 = inventory[idx2] if not idx2_is_in_hotbar else hotbar[idx2]
	
	if not idx1_is_in_hotbar:
		inventory[idx1] = item2
	else: 
		hotbar[idx1] = item2

	if not idx2_is_in_hotbar:
		inventory[idx2] = item1
	else: 
		hotbar[idx2] = item1
	
	send_inventory()
	send_hotbar()

# Remove items from the inventory based on crafting blueprint requirements
func delete_crafting_blueprint_cost(costs: Array[BlueprintCostData]) -> void:
	for cost in costs:
		for i in cost.amount:
			delete_item(cost.item_key)

# Remove an item from a specific index in the inventory or hotbar
func delete_item_by_index(idx : int, is_in_hotbar : bool) -> void:
	if is_in_hotbar:
		hotbar[idx] = null
		send_hotbar()
	else:
		inventory[idx] = null
		send_inventory()

# Add an item at a specific index in the inventory or hotbar
func add_item_by_index(item_key : ItemConfig.Keys, idx : int, is_in_hotbar : bool) -> void:
	if is_in_hotbar:
		hotbar[idx] = item_key
		send_hotbar()
	else:
		inventory[idx] = item_key
		send_inventory()

# Remove the last occurrence of a specific item from the inventory
func delete_item(item_key: ItemConfig.Keys) -> void:
	if not inventory.has(item_key):  # Check if the item exists in the inventory
		return
	inventory[inventory.rfind(item_key)] = null  # Remove the item from the last found position
