from pydantic import BaseModel, Field
from typing import List, Dict, Optional

class PlayerInput(BaseModel):
    """
    Represents the input JSON received from the Local Proxy Bridge.
    """
    player_id: str
    player_input: str
    history: List[str] = Field(default_factory=list) # Dialogue history (e.g., ["NPC: Hi!", "Player: Looking to survive?"])
    context: Dict[str, str] = Field(default_factory=dict) # Game context (e.g., {"location": "Forest", "quest_status": "incomplete"})

class NpcResponse(BaseModel):
    """
    Represents the structured JSON output the AI should generate.
    """
    npc_response: str
    emotion: str
    dialogue_type: str

class FallbackNpcResponse(NpcResponse):
    """
    Specific response model for fallback scenarios.
    """
    npc_response: str = "Hmm... I don't know what to say right now. Try again later!"
    emotion: str = "neutral"
    dialogue_type: str = "fallback"
