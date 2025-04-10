extends Node3D

# Manages equipping and unequipping items for the player.
# Handles item interactions and updates the currently equipped item.

var current_item_scene : Node3D  # Holds the currently equipped item

func _enter_tree() -> void:
	# Connects to global events for equipping and unequipping items
	EventSystem.EQU_equip_item.connect(equip_item)
	EventSystem.EQU_unequip_item.connect(unequip_item)

func try_to_use_item() -> void:
	# Attempts to use the currently equipped item, if any
	if current_item_scene == null:
		return
	current_item_scene.try_to_use()

func equip_item(item_key : ItemConfig.Keys) -> void:
	# Equips a new item by instantiating its scene and setting the appropriate data
	unequip_item()  # Unequip any currently equipped item before equipping a new one
	
	var item_scene := ItemConfig.get_equippable_item(item_key).instantiate()
	
	# Assign the correct resource data based on the type of item being equipped
	if item_scene is EquippableWeapon:
		item_scene.weapon_item_resource = ItemConfig.get_item_resource(item_key)
	elif item_scene is EquippableConsumable:
		item_scene.consumable_item_resource = ItemConfig.get_item_resource(item_key)
	elif item_scene is EquippableConstructable:
		item_scene.constructable_item_key = item_key
	
	add_child(item_scene)  # Add the new item to the scene tree
	current_item_scene = item_scene  # Store reference to the currently equipped item

func unequip_item() -> void:
	# Removes any currently equipped item
	for child in get_children():
		child.queue_free()  # Free all child nodes (removing the current item)
	current_item_scene = null  # Reset the equipped item reference
