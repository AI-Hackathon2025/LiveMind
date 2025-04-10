# Defines a configuration class for managing stage (scene) paths
class_name StageConfig

# Enum for stage identifiers, making it easier to reference different stages
enum Keys {
	Island,     # Represents the main game island stage
	MainMenu,   # Represents the main menu scene
	Credits     # Represents the credits scene
}

# Dictionary mapping stage keys to their corresponding file paths in the project
const STAGE_PATHS := {
	Keys.Island : "res://stages/island.tscn",         # Path to the Island stage scene
	Keys.MainMenu : "res://stages/main_menu.tscn",    # Path to the Main Menu scene
	Keys.Credits : "res://stages/credits.tscn"        # Path to the Credits scene
}

# Static function to retrieve and instantiate a stage based on its key
static func get_stage(key: Keys) -> Stage:
	return load(STAGE_PATHS.get(key)).instantiate()  # Loads the scene and creates an instance of it
