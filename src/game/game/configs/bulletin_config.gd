# Defines a configuration resource for different types of bulletins
class_name BulletinConfig

# Enumeration of different bulletin types
enum Keys {
	InteractionPrompt,  # Bulletin for interaction prompts
	CraftingMenu,       # Bulletin for the crafting menu
	CookingMenu,        # Bulletin for the cooking menu
	PauseMenu           # Bulletin for the pause menu
}

# Dictionary mapping bulletin keys to their respective scene paths
const BULLETIN_PATHS := {
	Keys.InteractionPrompt : "res://bulletins/interaction_prompt.tscn",
	Keys.CraftingMenu : "res://bulletins/player_menus/crafting_menu.tscn",
	Keys.CookingMenu : "res://bulletins/player_menus/cooking_menu.tscn",
	Keys.PauseMenu : "res://bulletins/pause_menu.tscn"
}

# Loads and returns an instance of the requested bulletin scene
static func get_bulletin(key: Keys) -> Bulletin:
	return load(BULLETIN_PATHS.get(key)).instantiate()
