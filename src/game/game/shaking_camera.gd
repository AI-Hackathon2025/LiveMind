extends Camera3D  # Extends Camera3D, making this a custom camera node
class_name ShakingCamera  # Assigns the class name "ShakingCamera" for reuse in other scripts

# Creates a new instance of FastNoiseLite for procedural noise generation
var noise := FastNoiseLite.new()

# Exposed variables to tweak camera shake effect in the editor
@export var noise_speed := 1.0  # Controls the speed of noise generation
@export var noise_multiplier := 0.25  # Determines the intensity of the shake effect

# Called when the node is ready
func _ready() -> void:
	noise.seed = randi()  # Generates a random seed for unique noise patterns
	noise.frequency = noise_speed * 0.00001  # Adjusts the frequency based on noise speed

# Called every frame to apply the shaking effect
func _process(_delta: float) -> void:
	# Uses noise to modify the camera's rotation, creating a shaking effect
	rotation.x = noise.get_noise_1d(Time.get_ticks_msec()) * noise_multiplier
	rotation.y = noise.get_noise_1d(Time.get_ticks_msec() + 10000) * noise_multiplier  # Offset ensures different values for X and Y
