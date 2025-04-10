extends Node  # This script extends the basic Node class

# Called when the node enters the scene tree
func _enter_tree() -> void:
	EventSystem.PLA_player_sleep.connect(start_sleep_sequence)  # Connects the sleep event to start the sleep sequence

# Starts the sleep sequence when the player initiates sleep
func start_sleep_sequence() -> void:
	EventSystem.PLA_freeze_player.emit()  # Freezes the player's movement and actions
	EventSystem.GAM_game_fade_in.emit(2, game_faded_in)  # Triggers a screen fade-in effect over 2 seconds, then calls game_faded_in()

# Handles actions after the fade-in completes
func game_faded_in() -> void:
	EventSystem.GAM_fast_forward_day_night_anim.emit(8)  # Fast-forwards the in-game time by 8 hours
	await get_tree().create_timer(1.5).timeout  # Waits for 1.5 seconds before proceeding
	EventSystem.PLA_unfreeze_player.emit()  # Unfreezes the player, allowing movement again
	EventSystem.GAM_game_fade_out.emit(1)  # Triggers a screen fade-out effect over 1 second
