extends CanvasLayer
class_name ChatManager
static var instance: Node = null

# preload emotions
const CALM = preload("res://assets/textures/ai_agent_emotions/calm.png")
const FRUSTRATED = preload("res://assets/textures/ai_agent_emotions/frustrated.png")
const HAPPY = preload("res://assets/textures/ai_agent_emotions/happy.png")
const SAD = preload("res://assets/textures/ai_agent_emotions/sad.png")
const THINKING = preload("res://assets/textures/ai_agent_emotions/thinking.png")
const PANEL_BEIGE = preload("res://assets/textures/panel_beige.png")

# onready variables
@onready var live_chat: Control = $AILiveChat
@onready var chat_field: TextureRect = $AILiveChat/ChatField
@onready var send_button: Button = $AILiveChat/ChatField/Button
@onready var line_edit: LineEdit = $AILiveChat/ChatField/LineEdit
@onready var close_button_livechat: Button = $AILiveChat/CloseButton
@onready var vbox_livechat: VBoxContainer = $AILiveChat/VBoxContainer
@onready var ai_emotion_livechat: TextureRect = $AILiveChat/AIEmotion
@onready var grey_bg_live_chat: TextureRect = $AILiveChat/GreyBGLiveChat

@onready var history: Control = $History
@onready var close_button_history: Button = $History/CloseButtonH
@onready var scroll_vbox_history: VBoxContainer = $History/ScrollContainer/VBoxContainer

@onready var PlayerTextLine = preload("res://ui/player_text_line.tscn")
@onready var AITextLine = preload("res://ui/ai_text_line.tscn")

# states
var chat_open = false
var history_open = false
var ai_visible = false
var thinking_timer: Timer
var pending_ai_result: Dictionary
var waiting_for_ai_response = false
var thinking_message_ref_livechat: Node = null

func _ready():
	instance = self
	live_chat.visible = false
	history.visible = false

	send_button.pressed.connect(_on_send_pressed)
	close_button_livechat.pressed.connect(_on_close_livechat_pressed)
	close_button_history.pressed.connect(_on_close_history_pressed)

	EventSystem.AI_agent_prompt_recieved.connect(_on_ai_prompt_received)

	thinking_timer = Timer.new()
	thinking_timer.wait_time = 2.0
	thinking_timer.one_shot = true
	thinking_timer.timeout.connect(_on_thinking_timeout)
	add_child(thinking_timer)
	

func _input(event):
	if event.is_action_pressed("toggle_chat") and not line_edit.has_focus():
		if not chat_open:
			_open_livechat()
		else:
			_close_livechat_input()
		get_viewport().set_input_as_handled()

	# Only toggle history if LineEdit is not focused (so we can type h normally)
	if event.is_action_pressed("toggle_history") and not line_edit.has_focus():
		if not history_open:
			_open_history()
		else:
			_close_history()
		get_viewport().set_input_as_handled()
		

func _open_livechat():
	chat_open = true
	history_open = false
	live_chat.visible = true
	chat_field.visible = true
	close_button_livechat.visible = true
	vbox_livechat.visible = true
	ai_emotion_livechat.visible = true
	grey_bg_live_chat.visible = true
	history.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	line_edit.grab_focus()
	EventSystem.PLA_freeze_player.emit()

func _close_livechat_input():
	chat_open = false
	chat_field.visible = false
	close_button_livechat.visible = false
	line_edit.release_focus()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventSystem.PLA_unfreeze_player.emit()

func _open_history():
	history_open = true
	chat_open = false
	history.visible = true
	live_chat.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventSystem.PLA_freeze_player.emit()

func _close_history():
	history_open = false
	_open_livechat()

func _on_close_livechat_pressed():
	_close_livechat_input()

func _on_close_history_pressed():
	_close_history()

func _on_send_pressed():
	var msg = line_edit.text.strip_edges()
	if msg.is_empty():
		return

	_add_player_message_to_history(msg)
	EventSystem.AI_notify_agent_on_user_prompt.emit(msg)
	line_edit.clear()

	_update_ai_emotion("thinking")
	waiting_for_ai_response = true
	thinking_timer.start()

	_add_thinking_message()

func _add_player_message_to_history(msg: String):
	# ONLY add to history, not to live chat
	var player_msg = PlayerTextLine.instantiate()
	player_msg.get_node("HBoxContainer/Label").text = msg
	scroll_vbox_history.add_child(player_msg)

func _on_ai_prompt_received(result: Dictionary):
	if not result.has("npc_response") or not result.has("emotion"):
		print("Invalid AI response")
		return

	if waiting_for_ai_response:
		pending_ai_result = result.duplicate()
	else:
		_display_ai_response(result)

func _on_thinking_timeout():
	waiting_for_ai_response = false
	if pending_ai_result:
		_display_ai_response(pending_ai_result)
		pending_ai_result.clear()

func _display_ai_response(result: Dictionary):
	var npc_response = result.get("npc_response", "")
	var emotion = result.get("emotion", "")

	_update_ai_emotion(emotion)

	# Clear live chat VBoxContainer first
	for child in vbox_livechat.get_children():
		child.queue_free()

	# Create a new AITextLine with cleared emotion icon for live chat
	var ai_msg_livechat = AITextLine.instantiate()
	var label_node = ai_msg_livechat.get_node("HBoxContainer/Label")
	label_node.text = npc_response
	label_node.autowrap_mode = TextServer.AUTOWRAP_WORD
	label_node.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var emotion_node = ai_msg_livechat.get_node("TextureRect/AIEmotion")
	var texture_node = ai_msg_livechat.get_node("TextureRect")
	emotion_node.texture = null
	texture_node.texture = null

	vbox_livechat.add_child(ai_msg_livechat)

	# Also add the full AI message with emotion to history
	var ai_msg_history = AITextLine.instantiate()
	ai_msg_history.get_node("HBoxContainer/Label").text = npc_response
	ai_msg_history.get_node("HBoxContainer/Label").autowrap_mode = TextServer.AUTOWRAP_WORD
	ai_msg_history.get_node("HBoxContainer/Label").size_flags_vertical = Control.SIZE_EXPAND_FILL
	ai_msg_history.get_node("TextureRect/AIEmotion").texture = _get_emotion_texture(emotion)
	ai_msg_history.get_node("TextureRect").texture = PANEL_BEIGE
	scroll_vbox_history.add_child(ai_msg_history)

func _add_thinking_message():
	for child in vbox_livechat.get_children():
		child.queue_free()

	thinking_message_ref_livechat = AITextLine.instantiate()
	var label_node = thinking_message_ref_livechat.get_node("HBoxContainer/Label")
	label_node.text = "Thinking..."
	label_node.autowrap_mode = TextServer.AUTOWRAP_WORD
	label_node.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var emotion_node = thinking_message_ref_livechat.get_node("TextureRect/AIEmotion")
	emotion_node.texture = null

	vbox_livechat.add_child(thinking_message_ref_livechat)

func _update_ai_emotion(emotion: String) -> void:
	match emotion.to_lower():
		"calm":
			ai_emotion_livechat.texture = CALM
		"frustrated":
			ai_emotion_livechat.texture = FRUSTRATED
		"happy":
			ai_emotion_livechat.texture = HAPPY
		"worried":
			ai_emotion_livechat.texture = SAD
		"thinking":
			ai_emotion_livechat.texture = THINKING
		_:
			ai_emotion_livechat.texture = null

func _get_emotion_texture(emotion: String) -> Texture:
	match emotion.to_lower():
		"calm":
			return CALM
		"frustrated":
			return FRUSTRATED
		"happy":
			return HAPPY
		"worried":
			return SAD
		"thinking":
			return THINKING
		_:
			return null

func hide_ai_prompt() -> void:
	vbox_livechat.visible = false
	ai_emotion_livechat.visible = false
	grey_bg_live_chat.visible = false
