# LiveMind

RealTime Adaptive Agents for AI-Survival Games

## Project Overview
LiveMind is a survival game that leverages an AI-powered backend to provide immersive and intelligent guidance to players. The AI backend integrates with Azure OpenAI services to deliver dynamic and context-aware responses, enhancing the gameplay experience.

## Prerequisites
1. Python 3.8 or higher.
2. Install dependencies using `pip`.
3. Azure OpenAI API credentials.

## Setup Instructions
1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd LiveMind
   ```

2. Create a virtual environment and activate it:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Configure environment variables:
   - Create a `.env` file in the `ai_backend/` directory.
   - Add the following variables:
     ```env
     AZURE_OPENAI_API_KEY=<your_api_key>
     AZURE_OPENAI_ENDPOINT=<your_endpoint>
     AZURE_OPENAI_DEPLOYMENT_NAME=mygpt-4.1
     AZURE_OPENAI_API_VERSION=2024-12-01-preview
     MAX_HISTORY_LENGTH=10
     ```

## Directory Structure
```
LiveMind/
├── ai_backend/
│   ├── __init__.py
│   ├── api.py
│   ├── azure_llm.py
│   ├── config.py
│   ├── env.yml
│   ├── main.py
│   ├── memory.py
│   ├── models.py
│   ├── prompt_engine.py
│   ├── README.md
│   ├── ws_adapter.py
│   └── __pycache__/
├── src/
│   └── game/
│       ├── actors/
│       │   ├── animals/
│       │   └── player/
│       ├── assets/
│       │   ├── audio/
│       │   ├── meshes/
│       │   └── textures/
│       ├── bulletins/
│       ├── game/
│       │   ├── configs/
│       │   └── managers/
│       ├── items/
│       ├── objects/
│       ├── particles/
│       ├── resources/
│       │   ├── item_resources/
│       │   └── materials/
│       ├── stages/
│       └── ui/
├── README.md
└── LICENSE
```

## Running the Project
1. Start the AI backend:
   ```bash
   uvicorn ai_backend.main:app --reload
   ```

2. Access the game and AI backend integration as per the game setup.

## Key Features
- AI-powered guidance for survival gameplay.
- Integration with Azure OpenAI for dynamic responses.
- Real-time interaction using WebSocket.

## Contribution Guidelines
1. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Commit your changes with a meaningful message.
3. Push the branch and create a pull request.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.
