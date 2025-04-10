extends Interactable  # Inherits from the base Interactable class

func start_interaction() -> void:
	# Emits an event to make the player sleep
	EventSystem.PLA_player_sleep.emit()
	
	# Plays a sound effect for entering a tent
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.GoInTent)
