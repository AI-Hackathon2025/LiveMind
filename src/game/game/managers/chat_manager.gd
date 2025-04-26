extends CanvasLayer

const CALM = preload("res://assets/textures/ai_agent_emotions/calm.png")
const FRUSTRATED = preload("res://assets/textures/ai_agent_emotions/frustrated.png")
const HAPPY = preload("res://assets/textures/ai_agent_emotions/happy.png")
const SAD = preload("res://assets/textures/ai_agent_emotions/sad.png")
const THINKING = preload("res://assets/textures/ai_agent_emotions/thinking.png")

@onready var v_box_container: VBoxContainer = $Control/ScrollContainer/VBoxContainer
@onready var button: Button = $Control/ChatField/Button
@onready var line_edit: LineEdit = $Control/ChatField/LineEdit
@onready var close_button: Button = $CloseButton
@onready var ai_emotion: TextureRect = $AIEmotion

@onready var PlayerTextLine = preload("res://ui/player_text_line.tscn")
@onready var AITextLine = preload("res://ui/ai_text_line.tscn")

var chat_open = false
var thinking_timer: Timer
var pending_ai_result: Dictionary
var waiting_for_ai_response = false
var thinking_message_ref: Node = null

func _ready():
	visible = false
	button.pressed.connect(_on_send_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	EventSystem.AI_agent_prompt_recieved.connect(_on_ai_prompt_received)
	
	# Initialize the thinking timer
	thinking_timer = Timer.new()
	thinking_timer.wait_time = 2.0
	thinking_timer.one_shot = true
	thinking_timer.timeout.connect(_on_thinking_timeout)
	add_child(thinking_timer)

func _input(event):
	if chat_open:
		if event.is_action_pressed("ui_cancel"):
			_close_chat()
	else:
		if event.is_action_pressed("toggle_chat"):
			_open_chat()
			get_viewport().set_input_as_handled()

func _open_chat():
	chat_open = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	line_edit.grab_focus()
	EventSystem.PLA_freeze_player.emit()

func _close_chat():
	chat_open = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventSystem.PLA_unfreeze_player.emit()

func _on_close_button_pressed():
	_close_chat()

func _on_send_pressed():
	var msg = line_edit.text.strip_edges()
	if msg.is_empty():
		return

	_add_player_message(msg)
	EventSystem.AI_notify_agent_on_user_prompt.emit(msg)
	line_edit.clear()

	# Start thinking animation immediately
	_update_ai_emotion("thinking")
	waiting_for_ai_response = true
	thinking_timer.start()

	# Add a dummy AI "thinking..." message
	_add_thinking_message()

func _add_player_message(msg: String):
	var player_msg = PlayerTextLine.instantiate()
	var label_node = player_msg.get_node("HBoxContainer/Label")
	label_node.text = msg
	v_box_container.add_child(player_msg)

func _on_ai_prompt_received(result: Dictionary):
	if not result.has("npc_response") or not result.has("emotion"):
		print("Invalid AI response")
		return

	if waiting_for_ai_response:
		# Save the result, but don't display yet
		pending_ai_result = result.duplicate()
	else:
		# If timer already finished, show immediately
		_display_ai_response(result)

func _on_thinking_timeout():
	waiting_for_ai_response = false
	if pending_ai_result:
		_display_ai_response(pending_ai_result)
		pending_ai_result.clear()

func _display_ai_response(result: Dictionary):
	var npc_response = result.get("npc_response", "")
	var emotion = result.get("emotion", "")

	if thinking_message_ref and is_instance_valid(thinking_message_ref):
		var label_node = thinking_message_ref.get_node("HBoxContainer/Label")
		label_node.text = npc_response

		var emotion_node = thinking_message_ref.get_node("TextureRect/AIEmotion")
		emotion_node.texture = _get_emotion_texture(emotion)
	else:
		_add_ai_message(npc_response, emotion)

	_update_ai_emotion(emotion)

	# Clear the reference after using it
	thinking_message_ref = null

func _add_ai_message(msg: String, emotion: String):
	var ai_msg = AITextLine.instantiate()
	
	var label_node = ai_msg.get_node("HBoxContainer/Label")
	label_node.text = msg
	label_node.autowrap_mode = TextServer.AUTOWRAP_WORD
	label_node.size_flags_vertical = Control.SIZE_EXPAND_FILL

	# Set emotion icon inside this ai_msg
	var emotion_node = ai_msg.get_node("TextureRect/AIEmotion")
	emotion_node.texture = _get_emotion_texture(emotion)

	v_box_container.add_child(ai_msg)

func _add_thinking_message():
	thinking_message_ref = AITextLine.instantiate()
	
	var label_node = thinking_message_ref.get_node("HBoxContainer/Label")
	label_node.text = "Thinking..."
	label_node.autowrap_mode = TextServer.AUTOWRAP_WORD
	label_node.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var emotion_node = thinking_message_ref.get_node("TextureRect/AIEmotion")
	emotion_node.texture = _get_emotion_texture("thinking")

	v_box_container.add_child(thinking_message_ref)


func _update_ai_emotion(emotion: String) -> void:
	match emotion.to_lower():
		"calm":
			ai_emotion.texture = CALM
		"frustrated":
			ai_emotion.texture = FRUSTRATED
		"happy":
			ai_emotion.texture = HAPPY
		"sad":
			ai_emotion.texture = SAD
		"thinking":
			ai_emotion.texture = THINKING
		_:
			ai_emotion.texture = null

func _get_emotion_texture(emotion: String) -> Texture:
	match emotion.to_lower():
		"calm":
			return CALM
		"frustrated":
			return FRUSTRATED
		"happy":
			return HAPPY
		"sad":
			return SAD
		"thinking":
			return THINKING
		_:
			return null
