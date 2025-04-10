extends Resource

# Defines a data structure to represent the cost of crafting an item in a blueprint
class_name BlueprintCostData

# The item required for crafting (default is Stick)
@export var item_key := ItemConfig.Keys.Stick

# The amount of the item required for crafting (default is 1)
@export var amount := 1
