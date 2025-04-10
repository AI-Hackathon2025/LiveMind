extends Area3D

# Signal emitted when the object is hit
signal register_hit

# Configurable sound effect key for the hit sound
@export var hit_audio_key := SFXConfig.Keys.TreeHit

# Called when this object is hit by a weapon
# `weapon_item_resource` contains information about the weapon used
func take_hit(weapon_item_resource: WeaponItemResource) -> void:
	# Emits the `register_hit` signal, passing the weapon data
	register_hit.emit(weapon_item_resource)
	
	# Plays the hit sound effect at the object's global position
	EventSystem.SFX_play_dynamic_sfx.emit(hit_audio_key, global_position)
