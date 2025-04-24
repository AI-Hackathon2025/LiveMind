import logging
from fastapi import APIRouter, HTTPException, Body

from models import PlayerInput, NpcResponse, FallbackNpcResponse
from prompt_engine import create_prompt_messages
from azure_llm import get_llm_response
from memory import get_history, add_to_history
# Removed cache-related imports
# from .cache import generate_cache_key, get_cached_response, store_response_in_cache

logger = logging.getLogger(__name__)
router = APIRouter()

@router.post("/generate_response", response_model=NpcResponse)
async def generate_npc_response(
    player_input: PlayerInput = Body(...) # Receive data in request body
):
    """
    Endpoint to generate NPC response based on player input, context, and history.
    Retrieves history from backend memory, calls LLM, and updates memory.
    (Removed caching logic)
    """
    logger.info(f"Received request for player_id: {player_input.player_id}")

    # --- Removed cache check logic ---
    # cache_key = generate_cache_key(player_input)
    # cached_response = get_cached_response(cache_key)
    # if cached_response:
    #     return cached_response
    # logger.info(f"Proceeding to LLM call for player {player_input.player_id}")

    # --- Integrate History (for LLM context) ---
    try:
        current_history = get_history(player_input.player_id)
        player_input.history = current_history # Use history from memory
        logger.info(f"Retrieved history for player {player_input.player_id}. Length: {len(current_history)}")
    except Exception as e:
        # Log error but continue if memory retrieval fails (LLM will get empty history)
        logger.error(f"Error retrieving history for player {player_input.player_id}: {e}", exc_info=True)
        # Ensure history is a list even if retrieval failed
        player_input.history = []

    # --- Create Prompt Messages ---
    try:
        messages = create_prompt_messages(player_input)
    except Exception as e:
        logger.error(f"Error creating prompt messages: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail="Internal server error: Failed to build prompt")

    # --- Get Response from LLM ---
    try:
        npc_response_obj = await get_llm_response(messages, player_input)
    except Exception as e:
        # Catch any unexpected errors from the LLM call not handled internally
        logger.error(f"Unhandled error during LLM call: {e}", exc_info=True)
        npc_response_obj = FallbackNpcResponse() # Return fallback on error

    # --- Update History (Cache update removed) ---
    if not isinstance(npc_response_obj, FallbackNpcResponse):
        # Removed cache update
        # try:
        #     store_response_in_cache(cache_key, npc_response_obj)
        # except Exception as e:
        #     logger.error(f"Error storing response in cache for key {cache_key[:8]}...: {e}", exc_info=True)

        # Update history (memory.py)
        try:
            add_to_history(player_input.player_id, player_input.player_input, npc_response_obj.npc_response)
            logger.info(f"Updated history for player {player_input.player_id}")
        except Exception as e:
            # Log memory update error, but don't fail the request
            logger.error(f"Error updating history for player {player_input.player_id}: {e}", exc_info=True)
    else:
         # Log message remains the same, but now only pertains to history
         logger.warning(f"Fallback response generated for player {player_input.player_id}. History not updated.")

    # --- Return Response ---
    # FastAPI will automatically serialize the Pydantic model to JSON
    return npc_response_obj

# Health check endpoint remains the same
@router.get("/health")
async def health_check():
    return {"status": "ok"}
