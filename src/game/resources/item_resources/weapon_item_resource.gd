# This script defines a specialized item resource for weapons.
# It extends the base ItemResource class to add weapon-specific properties.

extends ItemResource
class_name WeaponItemResource

# The amount of damage the weapon deals to an entity upon impact
@export var damage := 20.0

# The effective range of the weapon (e.g., melee or ranged attack distance)
@export var range := 1.5

# The energy cost per use (e.g., stamina reduction when swinging a sword)
@export var energy_change_per_use := -7
