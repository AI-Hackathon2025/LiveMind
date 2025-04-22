from fastapi import FastAPI
from api import router as api_router
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="NPC AI Backend",
    description="Provides AI-powered responses for game NPCs using Azure OpenAI.",
    version="0.1.0",
)

# Include the API router
app.include_router(api_router, prefix="/api") # Prefix all API routes with /api

@app.on_event("startup")
async def startup_event():
    logger.info("AI Backend application startup complete.")
    # You could add checks here, e.g., try a dummy call to Azure to verify connection

@app.on_event("shutdown")
async def shutdown_event():
    logger.info("AI Backend application shutting down.")

# Root endpoint (optional)
@app.get("/")
async def root():
    return {"message": "Welcome to the NPC AI Backend!"}

# If running directly using `python main.py` (for simple testing)
# Use `uvicorn main:app --reload` for development
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
