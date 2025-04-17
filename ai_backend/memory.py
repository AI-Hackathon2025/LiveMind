from collections import defaultdict, deque
from typing import List, Dict

# Simple in-memory storage for dialogue history per player
# Using deque for efficient appending and potential fixed-size history
# Key: player_id, Value: deque of dialogue strings
player_histories: Dict[str, deque] = defaultdict(lambda: deque(maxlen=config.MAX_HISTORY_LENGTH * 2 + 5)) # Store slightly more than needed for prompt

def get_history(player_id: str) -> List[str]:
    """Retrieves the dialogue history for a player."""
    return list(player_histories[player_id])

def add_to_history(player_id: str, user_input: str, npc_response: str):
    """Adds a user input and NPC response to the player's history."""
    history = player_histories[player_id]
    # Simple formatting, adjust as needed
    history.append(f"Player: {user_input}")
    history.append(f"NPC: {npc_response}")
    # Deque automatically handles maxlen rotation if limit is reached

# You might want functions to load/save history if persistence is needed later