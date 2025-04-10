extends ItemResource

# Defines a resource for consumable items, such as food or potions
class_name ConsumableItemResource

# The amount of health restored or lost when consumed (default: 15)
@export var health_change := 15

# The amount of energy restored or lost when consumed (default: 15)
@export var energy_change := 15
