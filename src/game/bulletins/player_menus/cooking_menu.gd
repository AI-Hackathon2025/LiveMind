extends PlayerMenuBase

# References to UI elements in the cooking menu
@onready var starting_cooking_slot: StartingCookingSlot = %StartingCookingSlot  # Slot for the uncooked item
@onready var final_cooking_slot: FinalCookingSlot = %FinalCookingSlot  # Slot for the cooked item
@onready var cooking_progress_bar: TextureProgressBar = %CookingProgressBar  # Progress bar for cooking time
@onready var cook_button: Button = %CookButton  # Button to start cooking

# Cooking-related variables
var cooking_recipe: CookinRecipeResource  # Stores the recipe for the current item being cooked
var time_cooked: float  # Tracks how much time has been cooked
var cooker: InteractableCooker  # Reference to the cooking station interacting with this menu
var cooking_state: InteractableCooker.CookingStates  # Tracks the current cooking state

# Initializes the menu with relevant cooking data
func initialize(extra_arg) -> void:
	if not extra_arg or not extra_arg is Array:
		return
	cooking_recipe = extra_arg[0]  # Recipe being used
	time_cooked = extra_arg[1]  # Time already cooked (if resumed)
	cooker = extra_arg[2]  # Reference to the cooker
	cooking_state = extra_arg[3]  # The current state of the cooking process

# Called when the menu is ready
func _ready() -> void:
	# Connects mouse events to show and hide item information
	starting_cooking_slot.mouse_entered.connect(show_item_info.bind(starting_cooking_slot))
	starting_cooking_slot.mouse_exited.connect(hide_item_info)
	final_cooking_slot.mouse_entered.connect(show_item_info.bind(final_cooking_slot))
	final_cooking_slot.mouse_exited.connect(hide_item_info)

	# Connects ingredient slot events to their respective functions
	starting_cooking_slot.starting_ingrediant_enabled.connect(uncooked_item_added)
	starting_cooking_slot.starting_ingrediant_disabled.connect(uncooked_item_removed)
	final_cooking_slot.cooked_food_taken.connect(cooker.cooked_item_removed)

	# Sets up the UI based on the current cooking state
	if cooking_state == InteractableCooker.CookingStates.ReadyToCook:
		starting_cooking_slot.set_item_key(cooking_recipe.uncooked_item)
		cook_button.disabled = false  # Enable cooking button
	elif cooking_state == InteractableCooker.CookingStates.Cooking:
		starting_cooking_slot.set_item_key(cooking_recipe.uncooked_item)
		start_cooking()  # Resume cooking if already in progress
	elif cooking_state == InteractableCooker.CookingStates.Cooked:
		final_cooking_slot.set_item_key(cooking_recipe.cooked_item)  # Display cooked item

	super()

# Called when an uncooked item is placed in the slot
func uncooked_item_added() -> void:
	cook_button.disabled = false  # Enable the cook button
	cooking_recipe = ItemConfig.get_item_resource(starting_cooking_slot.item_key).cooking_recipe  # Get the recipe
	time_cooked = 0  # Reset cooking time
	cooker.uncooked_item_added(cooking_recipe)  # Notify the cooker

# Called when an uncooked item is removed from the slot
func uncooked_item_removed() -> void:
	cook_button.disabled = true  # Disable the cook button
	cooking_recipe = null  # Clear the recipe
	time_cooked = 0  # Reset cooking time
	cooker.uncooked_item_removed()  # Notify the cooker

# Starts the cooking process
func start_cooking() -> void:
	starting_cooking_slot.cooking_in_progress = true  # Indicate cooking has started
	cook_button.disabled = true  # Disable the cook button during cooking
	cooking_progress_bar.value = time_cooked / cooking_recipe.cooking_time  # Set initial progress

	# Create a tween to animate the cooking progress bar
	var tween := create_tween()
	tween.tween_property(
		cooking_progress_bar,
		"value",
		cooking_progress_bar.max_value,  # Progress bar fills completely
		cooking_recipe.cooking_time - time_cooked  # Adjust time if cooking was already in progress
	)
	tween.tween_callback(finished_cooking)  # Callback when cooking is done

	# Start cooking if not already cooking
	if cooking_state != InteractableCooker.CookingStates.Cooking:
		cooker.start_cooking()  # Notify the cooker
		EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)  # Play UI sound effect

# Called when cooking is finished
func finished_cooking() -> void:
	final_cooking_slot.set_item_key(cooking_recipe.cooked_item)  # Move cooked item to final slot
	starting_cooking_slot.set_item_key(null)  # Clear the starting slot
	cooking_progress_bar.value = 0  # Reset progress bar
	starting_cooking_slot.cooking_in_progress = false  # Mark cooking as complete

# Closes the cooking menu
func close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Restore mouse control
	EventSystem.BUL_distroy_bulletin.emit(BulletinConfig.Keys.CookingMenu)  # Close the cooking menu
	EventSystem.PLA_unfreeze_player.emit()  # Unfreeze the player
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.UIClick)  # Play UI sound effect
	EventSystem.UI_show_interaction_propmt.emit()  # Show interaction prompt
	# Shows quests again after closing the menu.
	EventSystem.QU_show_quests.emit()
