extends ColorRect
class_name GameFadeController

func _enter_tree() -> void:
	# Connects fade-in and fade-out signals to their respective functions
	EventSystem.GAM_game_fade_in.connect(fade_in)
	EventSystem.GAM_game_fade_out.connect(fade_out)

# Handles fade-in effect
# `fade_time` determines the duration of the fade-in
# `maybe_callback` is an optional function that gets called after the fade-in completes
func fade_in(fade_time : float, maybe_callback = null) -> void:
	var tween := create_tween()
	
	# Fades the screen to black over the given time
	tween.tween_property(self, "color", Color.BLACK, fade_time)
	
	# Ensures volume remains at full (1.0) while fading in
	tween.parallel().tween_method(set_master_volume, 1.0, 1.0, fade_time)
	
	# Calls the provided callback function if it exists
	if maybe_callback is Callable:
		tween.tween_callback(maybe_callback)

# Handles fade-out effect
# `fade_time` determines the duration of the fade-out
# `maybe_callback` is an optional function that gets called after the fade-out completes
func fade_out(fade_time : float, maybe_callback = null) -> void:
	var tween := create_tween()
	
	# Fades the screen from black to transparent over the given time
	tween.tween_property(self, "color", Color(0, 0, 0, 0), fade_time)
	
	# Gradually restores volume from 0.0 to full volume (1.0) while fading out
	tween.parallel().tween_method(set_master_volume, 0.0, 1.0, fade_time)
	
	# Calls the provided callback function if it exists
	if maybe_callback is Callable:
		tween.tween_callback(maybe_callback)

# Adjusts the master volume based on a linear scale
func set_master_volume(volume_linear: float) -> void:
	# Converts linear volume to decibels and applies it to the master audio bus
	AudioServer.set_bus_volume_db(0, linear_to_db(volume_linear))
