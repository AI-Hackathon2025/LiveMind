extends Resource
class_name HittableObjectAttributes

# Item key for the object’s drop when destroyed (default is a Log)
@export var drop_item_key := ItemConfig.Keys.Log

# Maximum health of the object before breaking
@export var max_health := 60

# List of weapon keys that can damage this object (default allows only Axes)
@export var weapon_filter : Array[ItemConfig.Keys] = [ItemConfig.Keys.Axe]
