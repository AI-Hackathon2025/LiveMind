extends Stage

# This script handles stage-specific functionality, including exiting to the main menu
# and handling input events.

# Emits an event to switch the stage to the main menu
func exit_to_menu() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)

# Handles unhandled input events, specifically checking for the "ui_cancel" action
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		exit_to_menu()  # Calls the function to return to the main menu
