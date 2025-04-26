extends Node

# Signals for handling bulletins (e.g., messages or notifications)
signal BUL_create_bulletin  # Triggered to create a new bulletin
signal BUL_distroy_bulletin  # Triggered to destroy a specific bulletin
signal BUL_distroy_all_bulletins  # Triggered to clear all bulletins

# Signals related to inventory management
signal INV_try_to_pickup_item  # Triggered when attempting to pick up an item
signal INV_ask_update_inventory  # Requests an update for the inventory
signal INV_inventory_updated  # Notifies that the inventory has been updated
signal INV_hotbar_updated  # Notifies that the hotbar has been updated
signal INV_switch_two_item_indexes  # Swaps two item positions in the inventory
signal INV_add_item  # Adds an item to the inventory
signal INV_delete_crafting_blueprint_cost  # Removes materials used in crafting
signal INV_delete_item_by_index  # Removes an item from inventory by index
signal INV_add_item_by_index  # Adds an item to inventory at a specific index

# Signals related to player status
signal PLA_freeze_player  # Freezes player movement/input
signal PLA_unfreeze_player  # Unfreezes player movement/input
signal PLA_change_energy  # Changes player's energy level
signal PLA_energy_updated  # Notifies when energy level updates
signal PLA_change_health  # Changes player's health level
signal PLA_health_updated  # Notifies when health updates
signal PLA_player_sleep  # Handles the player going to sleep

# Signals for equipping and unequipping items
signal EQU_hotkey_pressed  # Triggered when a hotkey is pressed
signal EQU_equip_item  # Equips an item
signal EQU_unequip_item  # Unequips an item
signal EQU_active_hotbar_slot_updated  # Notifies when the active hotbar slot changes
signal EQU_delete_equipped_item  # Removes the currently equipped item

# Signals for spawning objects
signal SPA_spawn_scene  # Spawns a new scene (e.g., object or entity)

# Signals for sound effects and music
signal SFX_play_sfx  # Plays a sound effect
signal SFX_play_dynamic_sfx  # Plays a dynamic sound effect
signal MUS_play_music  # Plays background music

# Signals for game mechanics and world updates
signal GAM_fast_forward_day_night_anim  # Fast-forwards time (day/night cycle)
signal GAM_game_fade_in  # Triggers a fade-in effect
signal GAM_game_fade_out  # Triggers a fade-out effect
signal GAM_update_navmesh  # Updates the navigation mesh for pathfinding

# Signals for HUD (Heads-Up Display) management
signal HUD_hide_hud  # Hides the HUD
signal HUD_show_hud  # Shows the HUD

# Signals for UI interactions
signal UI_hide_interaction_propmt  # Hides an interaction prompt
signal UI_show_interaction_propmt  # Shows an interaction prompt

# Signals for stage transitions
signal STA_change_stage  # Changes the current game stage (e.g., switching levels)

# Signals for handling Quests
signal QU_quest_started
signal QU_quest_finished
signal QU_quest_updated
signal QU_show_quests
signal QU_hide_quests

# Signals for handling AI Agent
signal AI_notify_agent_on_user_prompt
signal AI_agent_prompt_recieved
