import json
import logging
from openai import AzureOpenAI, APIError, RateLimitError, APIConnectionError
from typing import List, Dict, Optional

import config
from models import NpcResponse, FallbackNpcResponse

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Azure OpenAI Client
# Ensure you have set the required environment variables:
# AZURE_OPENAI_API_KEY, AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_DEPLOYMENT_NAME

print(f"""Configuration Check:
Key: {config.AZURE_OPENAI_API_KEY[:5]}... (length: {len(config.AZURE_OPENAI_API_KEY)})
Endpoint: {config.AZURE_OPENAI_ENDPOINT}
Deployment: {config.AZURE_OPENAI_DEPLOYMENT_NAME}
API Version: {config.AZURE_OPENAI_API_VERSION}""")

try:
    client = AzureOpenAI(
        api_key=config.AZURE_OPENAI_API_KEY,
        api_version=config.AZURE_OPENAI_API_VERSION,
        azure_endpoint=config.AZURE_OPENAI_ENDPOINT,
        # Consider adding timeout configurations if needed
        # max_retries=3,
        # timeout=30.0,
    )
except Exception as e:
    logger.error(f"Failed to initialize AzureOpenAI client: {e}")
    client = None # Indicate client initialization failure

async def get_llm_response(messages: List[Dict[str, str]]) -> NpcResponse:
    """
    Calls the Azure OpenAI Chat Completions API and parses the response.

    Args:
        messages: A list of message dictionaries (e.g., [{"role": "system", "content": "..."}, {"role": "user", "content": "..."}]).

    Returns:
        An NpcResponse object or FallbackNpcResponse on error.
    """
    if not client:
        logger.error("AzureOpenAI client not initialized. Returning fallback response.")
        return FallbackNpcResponse()

    try:
        logger.info(f"Sending request to Azure OpenAI (Deployment: {config.AZURE_OPENAI_DEPLOYMENT_NAME})...")
        logger.debug(f"Messages: {messages}") # Uncomment for detailed debugging

        response = client.chat.completions.create(
            model = config.AZURE_OPENAI_DEPLOYMENT_NAME, # Your deployment name
            messages = messages,
            temperature = config.LLM_TEMPERATURE,
            max_tokens = config.LLM_MAX_TOKENS,
            response_format = {"type": "json_object"} # Request JSON output
        )

        response_content = response.choices[0].message.content
        logger.info("Received response from Azure OpenAI.")
        # logger.debug(f"Raw response content: {response_content}") # Uncomment for detailed debugging

        if not response_content:
             logger.warning("Received empty content from LLM. Returning fallback.")
             #todo - add meaningful fallback message here
             return FallbackNpcResponse()

        # Parse the JSON string from the LLM response
        try:
            parsed_json = json.loads(response_content)
            # Validate the structure using the Pydantic model
            npc_response = NpcResponse(**parsed_json)
            return npc_response
        except json.JSONDecodeError as json_err:
            logger.error(f"Failed to parse JSON response from LLM: {json_err}")
            logger.error(f"LLM Raw Response: {response_content}")
            return FallbackNpcResponse()
        except Exception as pydantic_err: # Catch potential Pydantic validation errors
             logger.error(f"Failed to validate LLM JSON response structure: {pydantic_err}")
             logger.error(f"Parsed JSON: {parsed_json}")
             return FallbackNpcResponse()

    except RateLimitError as rle:
        logger.error(f"Azure OpenAI rate limit exceeded: {rle}")
        return FallbackNpcResponse()
    except APIConnectionError as ace:
         logger.error(f"Azure OpenAI connection error: {ace}")
         return FallbackNpcResponse()
    except APIError as apie:
        logger.error(f"Azure OpenAI API error: {apie}")
        return FallbackNpcResponse()
    except Exception as e:
        logger.error(f"An unexpected error occurred while calling Azure OpenAI: {e}", exc_info=True)
        return FallbackNpcResponse()
