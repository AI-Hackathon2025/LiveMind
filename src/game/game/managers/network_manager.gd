extends Node

const SERVER_URL: String = "ws://127.0.0.1:8765"

var ws := WebSocketPeer.new()
var connected := false
var player_id: String = "p123"
var notification: String = "notification"
var prompt: String = "prompt"
var conversation_history: Array[String] = []

func _ready() -> void:
	EventSystem.AI_notify_agent_on_game_event.connect(notify_agent_on_game_event)
	var err = ws.connect_to_url(SERVER_URL)
	if err != OK:
		print("Failed to connect to WebSocket server. Error:", err)
	else:
		print("Connecting to server...")

func _process(_delta: float) -> void:
	ws.poll()

	var state = ws.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		if not connected:
			connected = true
			print("Connected to AI server!")
	elif state == WebSocketPeer.STATE_CLOSED:
		if connected:
			connected = false
			print("Disconnected from AI server.")
	
	while ws.get_available_packet_count() > 0:
		var msg = ws.get_packet().get_string_from_utf8()
		_on_message_received(msg)

func notify_agent_on_game_event(event_data: Dictionary) -> void:
	var context: Dictionary = event_data.get("context", {})

	var json_data := {
		"player_id": player_id,
		"type": notification,
		"player_input": null,
		"history": conversation_history,
		"context": context
	}

	var json_string := JSON.stringify(json_data)
	if connected:
		ws.send_text(json_string)
		print("Sent to AI Agent:", json_string)
	else:
		print("Cannot send data: Not connected.")

func notify_agent_on_user_prompt(event_data: Dictionary) -> void:
	var player_input: String = event_data.get("player_input", "Something happened")
	var context: Dictionary = event_data.get("context", {})

	conversation_history.append("Player: " + player_input)

	var json_data := {
		"player_id": player_id,
		"type": prompt,
		"player_input": player_input,
		"history": conversation_history,
		"context": context
	}

	var json_string := JSON.stringify(json_data)
	if connected:
		ws.send_text(json_string)
		print("Sent to AI Agent:", json_string)
	else:
		print("Cannot send data: Not connected.")

func _on_message_received(msg: String) -> void:
	var result = JSON.parse_string(msg)
	if result is Dictionary:
		print("NPC Response:", result.get("npc_response", ""))
		print("Emotion:", result.get("emotion", ""))
		print("Dialogue Type:", result.get("dialogue_type", ""))
	else:
		print("Failed to parse AI response.")
