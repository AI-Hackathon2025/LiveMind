import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Azure OpenAI Credentials
AZURE_OPENAI_API_KEY = "";
AZURE_OPENAI_ENDPOINT =  "https://dasun-m9oi4nso-swedencentral.openai.azure.com";
AZURE_OPENAI_DEPLOYMENT_NAME = os.getenv("AZURE_OPENAI_DEPLOYMENT_NAME", "mygpt-4.1") # Your deployment name for GPT-4o
AZURE_OPENAI_API_VERSION = os.getenv("AZURE_OPENAI_API_VERSION", "2024-12-01-preview") # Use an appropriate API version

# Basic validation
if not AZURE_OPENAI_API_KEY:
    raise ValueError("Missing environment variable: AZURE_OPENAI_API_KEY")
if not AZURE_OPENAI_ENDPOINT:
    raise ValueError("Missing environment variable: AZURE_OPENAI_ENDPOINT")

# --- Optional Settings ---
# Maximum history length (number of turns, where one turn is user+npc) to send to LLM
MAX_HISTORY_LENGTH = int(os.getenv("MAX_HISTORY_LENGTH", "10"))

# Default System Prompt (can be overridden or enhanced in prompt_engine.py)
DEFAULT_SYSTEM_PROMPT = """You are an NPC in a fantasy survival game. Your name is Kael, a grizzled forest ranger.

You respond to the player's questions and guide them based on their current context, location, and quest status provided in the user message.

Stay in character. Be immersive. Your responses should feel natural and appropriate to the player's situation.

Always respond ONLY with a valid JSON object following this structure, and nothing else:
{
  "npc_response": "<your message to the player>",
  "emotion": "<npc emotion, like calm, worried, excited, determined>",
  "dialogue_type": "<type: greeting, answer, warning, quest_hint, fallback, etc.>"
}
"""
