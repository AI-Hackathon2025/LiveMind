extends Node  # Extends the base Node class, making this a general-purpose scene manager
class_name Stage  # Defines a custom class name "Stage" for easy reference

# Signal emitted when the loading process is complete
signal loading_complete

# Exposed variable to determine whether the mouse should be visible
@export var show_mouse := false

# Exposed variable to set the background music for the stage
@export var music_to_play := MusicConfig.Keys.MainMenuSong

# Placeholder for handling node initialization (currently commented out)
#@export var nodes : Array[Node3D] = []
#var nodes_ready := 0

# Called when the node is added to the scene tree
func _ready() -> void:
	EventSystem.MUS_play_music.emit(music_to_play)  # Triggers music playback for the stage

	# Sets mouse visibility based on the `show_mouse` flag
	if show_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Shows the mouse
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Locks and hides the mouse for gameplay

	# The following timer was commented out; it may have been used for delaying loading completion
	# await get_tree().create_timer(2.0).timeout

	loading_complete.emit()  # Signals that the stage has finished loading

	# The following commented-out section appears to handle construction-related loading
	# It would track when all nodes finish their "build_completed" process before signaling completion.

	#for node in nodes:
		#if node.has_signal("build_completed"):
			#node.build_completed.connect(nodes_loaded)

# The function below was intended to track when all nodes finish building
# but is currently commented out.

#func nodes_loaded() -> void:
	#nodes_ready += 1
	#if nodes_ready >= nodes.size():
		#loading_complete.emit()
