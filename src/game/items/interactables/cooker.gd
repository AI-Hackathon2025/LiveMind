extends Interactable
class_name InteractableCooker

# References to child nodes
@onready var cooking_timer: Timer = $CookingTimer  # Timer for tracking cooking duration
@onready var food_visuals_holder: Marker3D = $FoodVisualsHolder  # Holds the visual representation of the food
@onready var fire_particles: GPUParticles3D = $GPUParticles3D  # Fire particle effect
@onready var fire_light: OmniLight3D = $OmniLight3D  # Light source representing fire
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D  # Audio for fire sound

@export var fire_always_on := true  # Determines if the fire should always be active

var cooking_recipe: CookinRecipeResource  # The current cooking recipe being used

# Enumeration for different states of the cooking process
enum CookingStates {
	Inactive,       # No food is in the cooker
	ReadyToCook,    # Uncooked food is placed, but not cooking
	Cooking,        # Food is currently being cooked
	Cooked          # Cooking is finished, food is ready
}
var state := CookingStates.Inactive  # Tracks the current state of the cooker

# Called when the node enters the scene
func _ready() -> void:
	if fire_always_on:
		fire_particles.emitting = true  # Enable fire particle effects
		fire_light.show()  # Show the fire light
		audio_stream_player.play()  # Play fire sound

# Starts the interaction with the cooker (e.g., opening the cooking menu)
func start_interaction() -> void:
	EventSystem.BUL_create_bulletin.emit(
		BulletinConfig.Keys.CookingMenu,
		[
			cooking_recipe,  # The current recipe
			0 if state != CookingStates.Cooking or not cooking_recipe else (cooking_recipe.cooking_time - cooking_timer.time_left),  # Remaining cook time if cooking
			self,  # Reference to this cooker instance
			state  # Current state of the cooker
		]
	)

# Called when an uncooked item is added to the cooker
func uncooked_item_added(recipe: CookinRecipeResource) -> void:
	state = CookingStates.ReadyToCook  # Set state to ready
	cooking_recipe = recipe  # Store the recipe
	# Instantiate and add the uncooked food visual
	food_visuals_holder.add_child(cooking_recipe.uncooked_item_visuals.instantiate())

# Called when the uncooked item is removed from the cooker
func uncooked_item_removed() -> void:
	state = CookingStates.Inactive  # Reset state
	cooking_recipe = null  # Clear the recipe
	clear_food_visuals()  # Remove visuals

# Called when the cooked item is removed from the cooker
func cooked_item_removed() -> void:
	state = CookingStates.Inactive  # Reset state
	cooking_recipe = null  # Clear the recipe
	clear_food_visuals()  # Remove visuals

# Clears all food-related visuals from the cooker
func clear_food_visuals() -> void:
	for child in food_visuals_holder.get_children():
		child.queue_free()  # Remove all children (food visuals)

# Starts the cooking process
func start_cooking() -> void:
	state = CookingStates.Cooking  # Set state to cooking
	cooking_timer.start(cooking_recipe.cooking_time)  # Start the timer

	if not fire_always_on:
		fire_particles.emitting = true  # Enable fire particle effects
		fire_light.show()  # Show the fire light
		audio_stream_player.play()  # Play fire sound

# Called when cooking is finished
func cooking_finished() -> void:
	state = CookingStates.Cooked  # Set state to cooked
	clear_food_visuals()  # Remove previous food visuals

	if not fire_always_on:
		fire_particles.emitting = false  # Disable fire particle effects
		fire_light.hide()  # Hide the fire light
		audio_stream_player.stop()  # Stop fire sound

	# Instantiate and add the cooked food visual
	food_visuals_holder.add_child(cooking_recipe.cooked_item_visuals.instantiate())
	
	# Complete Quests
	if cooking_recipe.cooked_item == ItemConfig.Keys.CookedMeat:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.CookMeat)
