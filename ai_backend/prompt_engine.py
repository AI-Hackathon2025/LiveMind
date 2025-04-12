from typing import List, Dict

from .models import PlayerInput
from . import config

def create_prompt_messages(player_input: PlayerInput) -> List[Dict[str, str]]:
    """
    Builds the list of messages for the LLM based on system prompt,
    context, history, and current player input.

    Applies simple history truncation.
    """
    messages = []

    # 1. System Prompt
    messages.append({"role": "system", "content": config.DEFAULT_SYSTEM_PROMPT})

    # 2. Context and History (formatted into the user message for simplicity here)
    #    A more sophisticated approach might interleave history turns.
    context_str = "\n".join([f"- {k.replace('_', ' ').capitalize()}: {v}" for k, v in player_input.context.items()])
    if not context_str:
        context_str = "No specific context provided."

    # Simple History Truncation: Keep only the last N turns (user + assistant)
    history_limit = config.MAX_HISTORY_LENGTH * 2 # Each turn has 2 entries
    truncated_history = player_input.history[-history_limit:]
    history_str = "\n".join(truncated_history) if truncated_history else "This is the beginning of your conversation."

    # 3. Current Player Input combined with context and history
    #    We combine context, history, and the new input into one user message.
    #    Alternatively, history could be added as alternating user/assistant messages.
    user_content = f"""
    **Current Context:**
    {context_str}

    **Recent Conversation History:**
    {history_str}

    **Player says:** "{player_input.player_input}"

    Remember to respond ONLY with the JSON object containing npc_response, emotion, and dialogue_type.
    """
    messages.append({"role": "user", "content": user_content.strip()})

    return messages
