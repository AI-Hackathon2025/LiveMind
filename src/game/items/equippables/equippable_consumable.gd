extends EquippableItem
class_name EquippableConsumable

# This script handles consumable items (e.g., food, potions).
# It applies effects to the player when consumed and removes the item.

# Holds the resource data for the consumable item
var consumable_item_resource : ConsumableItemResource

# Called when the item is consumed
func consume() -> void:
	EventSystem.PLA_change_health.emit(consumable_item_resource.health_change)  # Apply health effect
	EventSystem.PLA_change_energy.emit(consumable_item_resource.energy_change)  # Apply energy effect
	EventSystem.EQU_delete_equipped_item.emit()  # Remove item from inventory after use
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.Eat)  # Play eating sound effect
	EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.EatSomething)
	
# Called when the item is unequipped or destroyed
func destroy_self() -> void:
	EventSystem.EQU_unequip_item.emit()  # Unequip item without consuming it
