extends Stage

# Function triggered when the "Start" button is pressed
func _on_start_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Island)  # Switch to the Island stage

# Function triggered when the "Credits" button is pressed
func _on_credits_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Credits)  # Switch to the Credits stage

# Function triggered when the "Exit" button is pressed
func _on_exit_button_pressed() -> void:
	get_tree().quit()  # Exit the game
