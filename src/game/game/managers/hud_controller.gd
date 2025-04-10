extends Node

@onready var hud: Control = $HUD  # Reference to the HUD control node

func _enter_tree() -> void:
	# Connect HUD visibility events to their respective functions
	EventSystem.HUD_hide_hud.connect(hide_hud)
	EventSystem.HUD_show_hud.connect(show_hud)

func _ready() -> void:
	# Hide the HUD when the game starts
	hide_hud()

func hide_hud() -> void:
	# Remove the HUD from the scene tree, effectively hiding it
	remove_child(hud)

func show_hud() -> void:
	# Add the HUD back to the scene tree, making it visible again
	add_child(hud)
