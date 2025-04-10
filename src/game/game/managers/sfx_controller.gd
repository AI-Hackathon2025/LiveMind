extends AudioStreamPlayer  # This script extends AudioStreamPlayer, which plays audio streams in 2D
class_name SFXController  # Defines this script as SFXController, making it reusable across scenes

# Connects event signals to their respective functions when the node enters the scene tree
func _enter_tree() -> void:
	EventSystem.SFX_play_sfx.connect(play_sfx)  # Connects a signal to play standard SFX
	EventSystem.SFX_play_dynamic_sfx.connect(play_dynamic_sfx)  # Connects a signal to play 3D spatial SFX

# Called when the node is ready
func _ready() -> void:
	bus = "SFX"  # Assigns this audio player to the "SFX" audio bus

# Plays a standard sound effect using the provided key
func play_sfx(key : SFXConfig.Keys) -> void:
	stream = SFXConfig.get_audio_stream(key)  # Retrieves the corresponding audio stream
	play()  # Plays the sound effect

# Plays a dynamic (3D positioned) sound effect with optional pitch variation
func play_dynamic_sfx(key : SFXConfig.Keys, position : Vector3, pitch_rand := 0.0) -> void:
	var audio_player = AudioStreamPlayer3D.new()  # Creates a new 3D audio player
	add_child(audio_player)  # Adds it as a child to this node
	audio_player.bus = "SFX"  # Assigns it to the "SFX" audio bus
	audio_player.stream = SFXConfig.get_audio_stream(key)  # Retrieves the corresponding audio stream
	audio_player.pitch_scale = 1 + randf_range(-pitch_rand, pitch_rand)  # Randomizes pitch slightly if requested
	audio_player.global_position = position  # Positions the audio in 3D space
	audio_player.finished.connect(audio_player.queue_free)  # Destroys the audio player when the sound finishes playing
	audio_player.play()  # Starts playing the sound effect
