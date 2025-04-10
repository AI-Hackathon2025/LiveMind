extends Resource
class_name CookinRecipeResource

# Defines a resource for a cooking recipe, storing information about 
# the uncooked and cooked items, their visuals, and the required cooking time.

@export var uncooked_item := ItemConfig.Keys.RawMeat  # The key identifying the uncooked item
@export var uncooked_item_visuals: PackedScene  # Visual representation of the uncooked item
@export var cooked_item := ItemConfig.Keys.CookedMeat  # The key identifying the cooked item
@export var cooked_item_visuals: PackedScene  # Visual representation of the cooked item
@export var cooking_time := 5.0  # Time required (in seconds) to complete cooking
