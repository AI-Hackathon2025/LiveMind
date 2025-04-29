extends Node

const SERVER_URL: String = "ws://127.0.0.1:8765"

var ws := WebSocketPeer.new()
var connected := false
var player_id: String = "p123"
var notification: String = "notification"
var prompt: String = "prompt"
var conversation_history: Array[String] = []

func _ready() -> void:
	EventSystem.AI_notify_agent_on_user_prompt.connect(notify_agent_on_user_prompt)
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

func notify_agent_on_user_prompt(user_prompt: String) -> void:
	var inventory_summary := {}
	for item in InventoryManager.inventory:
		if item != null:
			var item_name = ItemConfig.enum_to_name(item)
			var current_count = int(inventory_summary[item_name]) if inventory_summary.has(item_name) else 0
			inventory_summary[item_name] = str(current_count + 1)

	# Ensure even 0-count items are strings (optional safety)
	for key in inventory_summary.keys():
		inventory_summary[key] = str(inventory_summary[key])

	var equipped_hotbar := {}
	for i in range(InventoryManager.hotbar.size()):
		var item = InventoryManager.hotbar[i]
		var key = "slot_%d" % (i + 1)
		equipped_hotbar[key] = str(ItemConfig.enum_to_name(item)) if item != null else "empty"

	var current_quest = QuestManager.quests[QuestManager.current_quest_index]

	var json_data := {
		"player_id": "player123",
		"player_input": user_prompt,
		"inventory": inventory_summary,
		"equipped_hotbar": equipped_hotbar,
		"context": {
			"health": "%d/100" % int(PlayerStatsManager.current_health),
			"stamina": "%d/100" % int(PlayerStatsManager.current_energy),
			"location": "forest",
			"time_of_day": str(DayNightManager.get_time_of_day())
		},
		"active_quest": {
			"quest_id": str(current_quest["key"]),
			"description": str(current_quest["text"])
		}
	}

	json_data["context"]["health"] = str(json_data["context"]["health"])
	json_data["context"]["stamina"] = str(json_data["context"]["stamina"])

	var json_string := JSON.stringify(json_data)
	if connected:
		ws.send_text(json_string)
		print("Sent to AI Agent:", json_string)
	else:
		print("Cannot send data: Not connected.")


func _on_message_received(msg: String) -> void:
	var result = JSON.parse_string(msg)
	EventSystem.AI_agent_prompt_recieved.emit(result)
	if result is Dictionary:
		print("NPC Response:", result.get("npc_response", ""))
		print("Emotion:", result.get("emotion", ""))
		print("Dialogue Type:", result.get("dialogue_type", ""))
	else:
		print("Failed to parse AI response.")
