import asyncio
import json
from aiohttp import ClientSession
import websockets

BACKEND_URL = "http://localhost:8000/api/generate_response"
WEBSOCKET_PORT = 8765

async def handle_client(websocket):
    print("Game client connected.")
    async with ClientSession() as session:
        try:
            async for message in websocket:
                print("Received from game:", message)

                try:
                    data = json.loads(message)
                except json.JSONDecodeError:
                    await websocket.send(json.dumps({
                        "npc_response": "Invalid JSON from client.",
                        "emotion": "confused",
                        "dialogue_type": "error"
                    }))
                    continue

                try:
                    async with session.post(BACKEND_URL, json=data) as response:
                        if response.status == 200:
                            result = await response.json()
                            await websocket.send(json.dumps(result))
                            print("Sent to game:", result)
                        else:
                            print("Backend error:", response.status)
                            await websocket.send(json.dumps({
                                "npc_response": "Backend error.",
                                "emotion": "frustrated",
                                "dialogue_type": "error"
                            }))
                except Exception as e:
                    print("Error calling backend:", e)
                    await websocket.send(json.dumps({
                        "npc_response": "Failed to contact AI backend.",
                        "emotion": "sad",
                        "dialogue_type": "error"
                    }))
        except websockets.exceptions.ConnectionClosed:
            print("Client disconnected.")

async def main():
    print(f"WebSocket wrapper listening on ws://localhost:{WEBSOCKET_PORT}")
    async with websockets.serve(handle_client, "localhost", WEBSOCKET_PORT):
        await asyncio.Future()  # Run forever

if __name__ == "__main__":
    asyncio.run(main())
