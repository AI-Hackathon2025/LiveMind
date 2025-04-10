class_name SFXConfig  # Defines this script as a configuration class for sound effects (SFX)

# Enum for different sound effect keys, making it easier to reference specific sounds
enum Keys {
	UIClick,        # Sound effect for UI button clicks
	ItemPickup,     # Sound effect for picking up an item
	Craft,          # Sound effect for crafting an item
	Build,          # Sound effect for building something
	Eat,            # Sound effect for eating food
	WeaponSwoosh,   # Sound effect for swinging a weapon
	TreeHit,        # Sound effect for hitting a tree (e.g., chopping wood)
	BoulderHit,     # Sound effect for hitting a boulder (e.g., mining)
	CowHurt,        # Sound effect when a cow takes damage
	CowAttack,      # Sound effect when a cow attacks
	WolfHurt,       # Sound effect when a wolf takes damage
	WolfAttack,     # Sound effect when a wolf attacks
	JumpLand,       # Sound effect for landing after a jump
	Footstep,       # Sound effect for player footsteps
	GoInTent        # Sound effect for entering a tent
}

# Dictionary mapping sound effect keys to their respective file paths
const FILE_PATHS := {
	Keys.UIClick : "res://assets/audio/sfx/ui_click.wav",
	Keys.ItemPickup : "res://assets/audio/sfx/item_pickup.wav",
	Keys.Craft : "res://assets/audio/sfx/craft.wav",
	Keys.Build : "res://assets/audio/sfx/build.wav",
	Keys.Eat : "res://assets/audio/sfx/eat.wav",
	Keys.WeaponSwoosh : "res://assets/audio/sfx/weapon_swoosh.wav",
	Keys.TreeHit : "res://assets/audio/sfx/tree_hit.wav",
	Keys.BoulderHit : "res://assets/audio/sfx/boulder_hit.wav",
	Keys.CowHurt : "res://assets/audio/sfx/cow_hurt.wav",
	Keys.CowAttack : "res://assets/audio/sfx/cow_attack.wav",
	Keys.WolfHurt : "res://assets/audio/sfx/wolf_hurt.wav",
	Keys.WolfAttack : "res://assets/audio/sfx/wolf_attack.wav",
	Keys.JumpLand : "res://assets/audio/sfx/jump_land.wav",
	Keys.Footstep : "res://assets/audio/sfx/footstep.wav",
	Keys.GoInTent : "res://assets/audio/sfx/go_in_tent.wav"
}

# Static function to load and return an AudioStream resource for a given sound key
static func get_audio_stream(key : Keys) -> AudioStream:
	return load(FILE_PATHS.get(key))  # Loads the corresponding audio file from the dictionary
