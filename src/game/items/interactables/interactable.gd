extends Area3D
class_name Interactable

@export var prompt := "Interact"  # The text prompt shown when the player can interact with this object

func start_interaction() -> void:
	# This function should be overridden by child classes to define specific interaction behavior
	pass
