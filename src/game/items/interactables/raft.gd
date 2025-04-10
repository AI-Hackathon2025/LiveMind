extends Interactable  # This script extends Interactable, meaning it represents an object the player can interact with.

# Handles the interaction when the player interacts with this object
func start_interaction() -> void:
	# Emits an event to change the game stage to the Credits screen
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Credits)
