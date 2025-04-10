extends Bulletin  # This script extends the Bulletin class, making it a type of bulletin UI element.

# Constants for colors and fade durations
const TRANSPARENT_COLOR = Color(0, 0, 0, 0)  # Fully transparent color
const BG_NORMAL_COLOR = Color(0, 0, 0, 0.7)  # Semi-transparent black background
const BG_FADE_TIME = 0.25  # Time in seconds for the background to fade in
const BUTTON_FADE_TIME = 0.15  # Time in seconds for buttons to fade in

# References to UI elements using @onready to initialize them when the node is ready
@onready var background : ColorRect = $ColorRect  # Background color rectangle
@onready var resume_button: Button = $VBoxContainer/ResumeButton  # Resume button
@onready var exit_button: Button = $VBoxContainer/ExitButton  # Exit button

# Called when the node is added to the scene
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Makes the mouse cursor visible
	background.color = TRANSPARENT_COLOR  # Set background initially to transparent
	resume_button.modulate = TRANSPARENT_COLOR  # Hide resume button initially
	exit_button.modulate = TRANSPARENT_COLOR  # Hide exit button initially
	fade_in()  # Start fade-in animation for the UI elements
	EventSystem.HUD_hide_hud.emit()  # Emit signal to hide the HUD

# Function to fade in the UI elements smoothly
func fade_in() -> void:
	create_tween().tween_property(background, "color", BG_NORMAL_COLOR, BG_FADE_TIME)  # Fade in background
	var tween := create_tween()  # Create a new tween animation
	tween.tween_property(resume_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)  # Fade in resume button
	tween.tween_property(exit_button, "modulate", Color.WHITE, BUTTON_FADE_TIME)  # Fade in exit button

# Function to fade out the UI and remove it from the scene
func fade_out() -> void:
	var tween := create_tween()  # Create a new tween animation
	tween.tween_property(self, "modulate", TRANSPARENT_COLOR, BG_FADE_TIME / 2.0)  # Fade out the entire UI
	tween.tween_callback(destroy_self)  # Call destroy_self when the fade-out completes
	EventSystem.HUD_show_hud.emit()  # Emit signal to show the HUD again

# Function to handle cleanup and removal of the bulletin
func destroy_self() -> void:
	EventSystem.BUL_distroy_bulletin.emit(BulletinConfig.Keys.PauseMenu)  # Emit signal to destroy the bulletin
	EventSystem.PLA_unfreeze_player.emit()  # Emit signal to unfreeze the player
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capture mouse input again

# Function called when the resume button is pressed
func _on_resume_button_pressed() -> void:
	fade_out()  # Start fade-out animation

# Function called when the exit button is pressed
func _on_exit_button_pressed() -> void:
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)  # Emit signal to change to the main menu
