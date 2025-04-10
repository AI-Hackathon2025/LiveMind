class_name MusicConfig

# Enum listing available music tracks
enum Keys {
	IslandAmbience,
	MainMenuSong,
	CreditsMusic
}

# Dictionary mapping music keys to their file paths
const FILE_PATHS := {
	Keys.IslandAmbience : "res://assets/audio/music/island_ambience.ogg",
	Keys.MainMenuSong : "res://assets/audio/music/transfixed_main_theme.ogg",
	Keys.CreditsMusic : "res://assets/audio/music/autumn_ending_theme.ogg"
}

# Function to load and return an AudioStream for a given music key
static func get_audio_stream(key: Keys) -> AudioStream:
	return load(FILE_PATHS.get(key))
