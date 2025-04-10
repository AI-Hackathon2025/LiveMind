extends Resource
class_name ItemResource  # Defines a resource type for items

# The unique key identifying this item, linked to ItemConfig.Keys
@export var item_key : ItemConfig.Keys  

# Display name of the item (for UI)
@export var display_name := "Item Name"  

# Icon for the item (used in inventory or UI elements)
@export var icon : Texture2D  

# Description of the item (supports multiple lines)
@export_multiline var description := "Description"  

# Whether the item can be equipped
@export var is_eqippable := false  

# Cooking recipe associated with this item (if applicable)
@export var cooking_recipe : CookinRecipeResource  # (Possible typo: Should be CookingRecipeResource?)
