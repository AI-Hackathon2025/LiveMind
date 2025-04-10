# This script manages stage transitions in the game, handling scene changes smoothly with a fade effect.
extends Node

# Constants
const FADE_TIME := 1.0  # Duration of the fade transition in seconds

# Variables
var thread := Thread.new()  # Thread to handle stage loading asynchronously
var is_stage_changing := false  # Flag to prevent multiple simultaneous stage changes

# Called when the node enters the scene tree
func _enter_tree() -> void:
	EventSystem.STA_change_stage.connect(start_stage_change_sequence)  
	# Connects the custom event for changing stages to the function that initiates the transition

# Called when the node is fully loaded
func _ready() -> void:
	start_stage_change_sequence(StageConfig.Keys.MainMenu)  
	# Starts the game by transitioning to the main menu when the game launches

# Initiates the stage transition sequence
func start_stage_change_sequence(key: StageConfig.Keys) -> void:
	if is_stage_changing:  # Prevents multiple stage changes from overlapping
		return
	is_stage_changing = true  # Sets the flag to indicate a stage change is in progress
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Captures the mouse to prevent unwanted clicks
	EventSystem.GAM_game_fade_in.emit(FADE_TIME, game_faded_in.bind(key))  
	# Starts the fade-in effect and calls 'game_faded_in' once the fade-in completes

# Called when the fade-in effect is complete, preparing for the new stage
func game_faded_in(stage_key : StageConfig.Keys) -> void:
	for child in get_children():
		child.queue_free()  # Removes all existing children (clearing the current stage)
	EventSystem.BUL_distroy_all_bulletins.emit()  # Clears all bulletin UI elements
	thread.start(load_stage.bind(stage_key))  # Starts a new thread to load the next stage asynchronously

# Loads the new stage in a separate thread to avoid frame drops
func load_stage(stage_key : StageConfig.Keys) -> void:
	var new_stage := StageConfig.get_stage(stage_key)  # Retrieves the new stage from StageConfig
	call_deferred("add_child", new_stage)  # Adds the new stage to the scene tree safely
	new_stage.loading_complete.connect(loading_complete)  # Connects to the loading complete signal
	call_deferred("join_thread")  # Ensures the thread joins back to the main process after loading

# Joins the thread back to the main process
func join_thread() -> void:
	thread.wait_to_finish()  # Waits for the thread to complete before proceeding

# Called when the new stage has finished loading
func loading_complete() -> void:
	EventSystem.GAM_game_fade_out.emit(FADE_TIME)  # Triggers the fade-out effect to reveal the new stage
	is_stage_changing = false  # Resets the flag, allowing future stage transitions
