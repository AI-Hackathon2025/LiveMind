extends RayCast3D  # This script extends RayCast3D to detect interactable objects in front of the player

var is_hitting := false  # Tracks whether the ray is currently hitting an interactable object

# Checks if the ray is colliding with an interactable object
func check_interaction() -> void:
	if is_colliding():
		var collider = get_collider()  # Get the object being collided with
		
		# Ensure the collided object is an Interactable; otherwise, return
		if not collider is Interactable:
			return
		
		# If the player presses the interaction button, trigger the interaction
		if Input.is_action_just_pressed("interact"):
			collider.start_interaction()
		
		# If this is the first time hitting the interactable, show the interaction prompt
		if not is_hitting:
			is_hitting = true
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.InteractionPrompt, collider.prompt)

	# If the ray is no longer hitting an interactable object, remove the prompt
	elif is_hitting:
		is_hitting = false
		EventSystem.BUL_distroy_bulletin.emit(BulletinConfig.Keys.InteractionPrompt)
