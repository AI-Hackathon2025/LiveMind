extends Bulletin  # Inherits from the Bulletin class

var prompt_text := ""  # Stores the text for the interaction prompt

# Initializes the prompt text if the provided value is a string
func initialize(prompt) -> void:
	if prompt is String:
		prompt_text = prompt
		
func _ready() -> void:
	# Sets the label text to the stored prompt text
	$Label.text = prompt_text
	
	# Connects event signals for showing and hiding the interaction prompt
	EventSystem.UI_hide_interaction_propmt.connect(hide_interaction_propmt)
	EventSystem.UI_show_interaction_propmt.connect(show_interaction_propmt)

# Hides the interaction prompt when the event is triggered
func hide_interaction_propmt() -> void:
	visible = false

# Shows the interaction prompt when the event is triggered
func show_interaction_propmt() -> void:
	visible = true
