class_name ItemConfig  # Defines a global item configuration class

# Enum listing all item keys, including pickable items and craftable items
enum Keys {
	# Pickuppable items (can be found in the world)
	Stick,
	Stone,
	Plant,
	Mushroom,
	Fruit,
	Log,
	Coal,
	Flintstone,
	RawMeat,
	CookedMeat,
	
	# Craftable items (created by crafting)
	Axe,
	Pickaxe,
	Campfire,
	Multitool,
	Rope,
	Tinderbox,
	Torch,
	Tent,
	Raft
}

# List of craftable item keys
const CRRAFTABLE_ITEM_KEYS : Array[Keys] = [
	Keys.Axe,
	Keys.Pickaxe,
	Keys.Campfire,
	Keys.Multitool,
	Keys.Rope,
	Keys.Tinderbox,
	Keys.Torch,
	Keys.Tent,
	Keys.Raft
]

# Dictionary mapping item keys to their respective resource files
const ITEM_RESOURCE_PATHS := {
	Keys.Stick : "res://resources/item_resources/stick_resource.tres",
	Keys.Stone : "res://resources/item_resources/stone_resource.tres",
	Keys.Plant : "res://resources/item_resources/plant_resource.tres",
	Keys.Mushroom : "res://resources/item_resources/mushroom_resource.tres",
	Keys.Fruit : "res://resources/item_resources/fruit_resource.tres",
	
	Keys.Axe : "res://resources/item_resources/axe_resource.tres",
	Keys.Pickaxe : "res://resources/item_resources/pickaxe_resource.tres",
	Keys.Torch : "res://resources/item_resources/torch_resource.tres",
	
	Keys.Rope : "res://resources/item_resources/rope_resource.tres",
	
	Keys.Log : "res://resources/item_resources/log_resource.tres",
	Keys.Coal : "res://resources/item_resources/coal_resource.tres",
	Keys.Flintstone : "res://resources/item_resources/flintstone_resource.tres",
	Keys.RawMeat : "res://resources/item_resources/raw_meat_resource.tres",
	
	Keys.CookedMeat : "res://resources/item_resources/cooked_meat_resource.tres",
	
	Keys.Tent : "res://resources/item_resources/tent_resource.tres",
	Keys.Campfire : "res://resources/item_resources/campfire_resource.tres",
	Keys.Raft : "res://resources/item_resources/raft_resource.tres",
	
	Keys.Multitool : "res://resources/item_resources/multitool_resource.tres",
	Keys.Tinderbox : "res://resources/item_resources/tinderbox_resource.tres"
}

# Function to retrieve an item's resource file
static func get_item_resource(key: Keys) -> ItemResource:
	return load(ITEM_RESOURCE_PATHS.get(key))

# Dictionary mapping craftable items to their blueprint resources
const CRAFTING_BLUEPRINT_RESOURCE_PATHS := {
	Keys.Axe : "res://resources/crafting_blueprint_resources/axe_blueprint.tres",
	Keys.Pickaxe : "res://resources/crafting_blueprint_resources/pickaxe_blueprint.tres",
	Keys.Torch : "res://resources/crafting_blueprint_resources/torch_blueprint.tres",
	Keys.Rope : "res://resources/crafting_blueprint_resources/rope_blueprint.tres",
	Keys.Raft : "res://resources/crafting_blueprint_resources/raft_blueprint.tres",
	Keys.Tent : "res://resources/crafting_blueprint_resources/tent_blueprint.tres",
	Keys.Campfire : "res://resources/crafting_blueprint_resources/campfire_blueprint.tres",
	Keys.Multitool : "res://resources/crafting_blueprint_resources/multitool_blueprint.tres",
	Keys.Tinderbox : "res://resources/crafting_blueprint_resources/tinderbox_blueprint.tres"
}

# Function to retrieve a crafting blueprint
static func get_crafting_blueprint_resource(key: Keys) -> CraftingBlueprintResource:
	return load(CRAFTING_BLUEPRINT_RESOURCE_PATHS.get(key))

# Dictionary mapping equippable items to their scene files
const EQUIPPABLE_ITEM_PATHS := {
	Keys.Axe : "res://items/equippables/equippable_axe.tscn",
	Keys.Pickaxe : "res://items/equippables/equippable_pickaxe.tscn",
	Keys.Torch : "res://items/equippables/equippable_torch.tscn",

	# Edible items that can be "equipped" (probably for consuming)
	Keys.Mushroom : "res://items/equippables/equippable_mushroom.tscn",
	Keys.CookedMeat : "res://items/equippables/equippable_cooked_meat.tscn",
	Keys.Fruit : "res://items/equippables/equippable_fruit.tscn",

	# Placeable items
	Keys.Tent : "res://items/equippables/equippable_tent.tscn",
	Keys.Campfire : "res://items/equippables/equippable_campfire.tscn",
	Keys.Raft : "res://items/equippables/equippable_raft.tscn",
}

# Function to retrieve an equippable item's scene
static func get_equippable_item(key: Keys) -> PackedScene:
	return load(EQUIPPABLE_ITEM_PATHS.get(key))

# Dictionary mapping pickuppable items to their scene files
const PICKUPPABLE_ITEM_PATHS := {
	Keys.Log : "res://items/interactables/rigid_pickuppable_log.tscn",
	Keys.Coal : "res://items/interactables/rigid_pickuppable_coal.tscn",
	Keys.Flintstone : "res://items/interactables/rigid_pickuppable_flintstone.tscn",
	Keys.RawMeat : "res://items/interactables/rigid_pickuppable_raw_meat.tscn"
}

# Function to retrieve a pickuppable item's scene
static func get_pickuppable_item(key: Keys) -> PackedScene:
	return load(PICKUPPABLE_ITEM_PATHS.get(key))

# Dictionary mapping constructable items to their scene files
const CONSTRUCTABLE_ITEM_PATHS := {
	Keys.Tent : "res://objects/constructables/constructable_tent.tscn",
	Keys.Campfire : "res://objects/constructables/constructable_campfire.tscn",
	Keys.Raft : "res://objects/constructables/constructable_raft.tscn"
}

# Function to retrieve a constructable item's scene
static func get_constructable_item(key: Keys) -> PackedScene:
	return load(CONSTRUCTABLE_ITEM_PATHS.get(key))

static func enum_to_name(enum_value: int) -> String:
	# Converts enum int (e.g., 11) to string name (e.g., "Multitool")
	return Keys.keys()[enum_value]
