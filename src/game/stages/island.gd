extends Node  # A simple Node responsible for playing background music

func _ready() -> void:
	# When the node is ready, trigger the event to play the background music
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.IslandAmbience)
