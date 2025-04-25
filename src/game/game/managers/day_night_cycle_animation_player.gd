extends AnimationPlayer

# This script controls the day-night animation system.
# It listens for an event to fast-forward the animation and initializes the time.
@onready var day_night_cycle_animation_player: AnimationPlayer = $"."

func _enter_tree() -> void:
	# Connects an event that allows fast-forwarding the day-night cycle animation
	EventSystem.GAM_fast_forward_day_night_anim.connect(fast_forward_anim)

func _ready() -> void:
	# Waits for the physics frame to ensure the scene tree is fully initialized
	await get_tree().physics_frame
	
	# Sets the initial time of the animation to midday (12:00)
	set_time(12)

#func _process(delta: float) -> void:
	#print("Current animation:", current_animation)
	#print("Position:", current_animation_position)

# Sets the animation to a specific time position
func set_time(time: float) -> void:
	seek(time)  # Moves the animation to the specified time

# Fast-forwards the animation by a given amount of time
func fast_forward_anim(time: float) -> void:
	# Advances the animation position while keeping it within its length using modulo
	seek(fmod(current_animation_position + time, current_animation_length))
	
func get_time_of_day() -> String:
	var hour = day_night_cycle_animation_player.current_animation_position
	if hour >= 10 and hour < 13:
		return "morning"
	elif hour >= 13 and hour < 21:
		return "day"
	elif hour >= 21 and hour < 24:
		return "evening"
	elif hour > 0 and hour < 10:
		return "night"
	else:
		return "day"
