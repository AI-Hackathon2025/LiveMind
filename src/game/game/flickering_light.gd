@tool
extends OmniLight3D
class_name FlickeringLight

# Noise generator for creating flickering effect
var noise := FastNoiseLite.new()

# Minimum and maximum light intensity (flicker range)
@export var min_energy := 0.9
@export var max_energy := 1.5

# Speed of flickering effect
@export var speed := 1.0

func _ready() -> void:
	# Set noise frequency based on speed
	noise.frequency = speed * 0.001
	
	# Randomize the noise seed for unique flickering each time
	noise.seed = randi()

func _process(_delta: float) -> void:
	# Adjust light intensity based on noise value
	# Uses time-based noise function to create a natural flicker effect
	light_energy = min_energy + noise.get_noise_1d(Time.get_ticks_msec()) * (max_energy - min_energy)
