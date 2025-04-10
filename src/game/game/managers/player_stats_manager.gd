extends Node  # This script extends Node and manages the player's energy and health.

# Constants defining the maximum values for energy and health
const MAX_ENERGY := 100.0  # Maximum energy a player can have
const MAX_HEALTH := 100.0  # Maximum health a player can have

# Variables to track the player's current energy and health
var current_energy = MAX_ENERGY  # Starts at max energy
var current_health = MAX_HEALTH  # Starts at max health

# Called when the node enters the scene tree
func _enter_tree() -> void:
	# Connects energy change events to the change_energy function
	EventSystem.PLA_change_energy.connect(change_energy)
	# Connects health change events to the change_health function
	EventSystem.PLA_change_health.connect(change_health)

# Handles changes in player energy
func change_energy(energy_change : float) -> void:
	# Adjusts the current energy based on the change value
	current_energy += energy_change
	
	# If energy drops below zero, the player takes damage proportional to the energy deficit
	if current_energy < 0:
		change_health(current_energy / 4)  # Converts excess negative energy loss into health damage

	# Ensures energy stays within valid limits (0 to MAX_ENERGY)
	current_energy = clampf(current_energy, 0, MAX_ENERGY)
	
	# Emits an event to update the UI or other game systems about the new energy value
	EventSystem.PLA_energy_updated.emit(MAX_ENERGY, current_energy)

# Handles changes in player health
func change_health(health_change : float) -> void:
	# Adjusts the player's health within the allowed range (0 to MAX_HEALTH)
	current_health = clampf(current_health + health_change, 0, MAX_HEALTH)
	
	# Emits an event to update the UI or other game systems about the new health value
	EventSystem.PLA_health_updated.emit(MAX_HEALTH, current_health)
