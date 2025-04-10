extends AudioStreamPlayer
class_name MusicController

func _ready() -> void:
	# Connect the event system to handle music playback
	EventSystem.MUS_play_music.connect(play_music)
	
	# Ensure this AudioStreamPlayer plays on the "Music" bus
	bus = "Music"

func play_music(key: MusicConfig.Keys) -> void:
	# Load and play the selected music track
	stream = MusicConfig.get_audio_stream(key)
	play()
