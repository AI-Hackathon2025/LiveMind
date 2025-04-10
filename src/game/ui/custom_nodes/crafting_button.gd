extends TextureRect

# UI component representing an item slot with an icon and a button.

@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect  # Displays the item icon
@onready var button: Button = $Button  # Button used for interactions (e.g., selecting or using the item)

var item_key  # Stores the key identifying the item in this slot

# Sets the item key and updates the displayed icon accordingly.
func set_item_key(_item_key) -> void:
	item_key = _item_key  # Store the new item key
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon  # Update the icon based on the item
