extends Resource
class_name CraftingBlueprintResource

# Defines a resource for a crafting blueprint, storing information about
# the crafted item, required materials, and any special tool requirements.

@export var item_key := ItemConfig.Keys.Axe  # The key identifying the item to be crafted
@export var cost: Array[BlueprintCostData] = []  # List of required materials for crafting
@export var needs_multitool := false  # Whether a multitool is required for crafting
@export var needs_tinderbox := false  # Whether a tinderbox is required for crafting (e.g., fire-based crafting)
