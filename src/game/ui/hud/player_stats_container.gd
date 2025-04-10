extends VBoxContainer  # This script extends VBoxContainer, meaning it's a vertical UI container.

# References to UI elements
@onready var energy_bar: TextureProgressBar = $EnergyBar  # Progress bar displaying the player's energy.
@onready var health_bar: TextureProgressBar = $HealthBar  # Progress bar displaying the player's health.

# Called when the node enters the scene tree
func _enter_tree() -> void:
	# Connects the energy update event to the energy_updated function
	EventSystem.PLA_energy_updated.connect(energy_updated)
	# Connects the health update event to the health_updated function
	EventSystem.PLA_health_updated.connect(health_updated)

# Updates the energy bar when the player's energy changes
func energy_updated(max_energy : float, current_energy : float) -> void:
	energy_bar.max_value = max_energy  # Sets the maximum energy value
	energy_bar.value = current_energy  # Updates the energy bar to reflect current energy

# Updates the health bar when the player's health changes
func health_updated(max_health : float, current_health : float) -> void:
	health_bar.max_value = max_health  # Sets the maximum health value
	health_bar.value = current_health  # Updates the health bar to reflect current health
