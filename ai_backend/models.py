from pydantic import BaseModel, Field
from typing import List, Dict, Optional


class InventoryTool(BaseModel):
    sticks: Optional[int] = 0
    stones: Optional[int] = 0
    plants: Optional[int] = 0
    logs: Optional[int] = 0
    coal: Optional[int] = 0
    flintstone: Optional[int] = 0
    axe: Optional[int] = 0
    pickaxe: Optional[int] = 0
    torch: Optional[int] = 0
    multitool: Optional[int] = 0
    ropes: Optional[int] = 0
    tinderbox: Optional[int] = 0
    raw_meat: Optional[int] = 0
    cooked_meat: Optional[int] = 0


class HotbarTool(BaseModel):
    slot_1: Optional[str] = "empty"
    slot_2: Optional[str] = "empty"
    slot_3: Optional[str] = "empty"
    slot_4: Optional[str] = "empty"
    slot_5: Optional[str] = "empty"
    slot_6: Optional[str] = "empty"
    slot_7: Optional[str] = "empty"
    slot_8: Optional[str] = "empty"
    slot_9: Optional[str] = "empty"

class QuestTool(BaseModel):
    quest_id: str
    description: str


class PlayerInput(BaseModel):
    """
    Represents the input JSON received from the Local Proxy Bridge.
    """
    player_id: str
    player_input: str
    history: List[str] = Field(default_factory=list)
    context: Dict[str, str] = Field(default_factory=dict) # Game context (e.g., {"location": "Forest", "quest_status": "incomplete"})
    inventory: InventoryTool
    equipped_hotbar: HotbarTool
    active_quest: Optional[QuestTool] = None


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