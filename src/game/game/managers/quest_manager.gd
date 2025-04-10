extends Node

var quests = QuestConfig.QUESTS
var current_quest_index = 0
var completed_quests = {}  # Tracks completed quests
@onready var quest_data_display_label = %QuestDataLabel  # Reference to UI Label
@onready var quest_container = %QuestContainer

func _ready():
	EventSystem.QU_quest_started.connect(quest_started)
	EventSystem.QU_quest_finished.connect(quest_finished)
	EventSystem.QU_quest_updated.connect(quest_updated)
	EventSystem.QU_show_quests.connect(show_quests)
	EventSystem.QU_hide_quests.connect(hide_quests)
	
	# Initialize all quests as incomplete
	for quest in quests:
		completed_quests[quest["key"]] = false

	# Start the first quest
	start_current_quest()

func show_quests() -> void:
	if quest_container:
		quest_container.visible = true  # Show the quest container

func hide_quests() -> void:
	if quest_container:
		quest_container.visible = false  # Hide the quest container
	
# Starts the current quest and updates the UI
func start_current_quest() -> void:
	if current_quest_index < quests.size():
		var quest = quests[current_quest_index]
		EventSystem.QU_quest_started.emit(quest["key"])
		fade_and_update_text(quest["text"])  # Apply fade effect
	else:
		fade_and_update_text("All objectives completed. Interact with the raft to Escape the Island!")  # Show in UI

# Called when a quest starts
func quest_started(quest_key: int) -> void:
	var quest = QuestConfig.get_quest_by_key(quest_key)
	if quest:
		fade_and_update_text("Current Quest: " + quest["text"])  # Apply fade effect
	else:
		fade_and_update_text("Error: Quest not found.")  # Show error in UI

# Called when a quest is updated
func quest_updated(quest_key: int) -> void:
	var quest = QuestConfig.get_quest_by_key(quest_key)
	if quest:
		fade_and_update_text("Quest Updated: " + quest["text"])  # Apply fade effect
	else:
		fade_and_update_text("Error: Quest not found.")  # Show error

# Called when a quest is finished
func quest_finished(quest_key: int) -> void:
	# Ensure quests are completed in order
	if quest_key != quests[current_quest_index].key:
		return
	
	# Prevent re-completing quests
	if completed_quests.get(quest_key, false):
		return
	
	var quest = QuestConfig.get_quest_by_key(quest_key)
	if quest:
		completed_quests[quest_key] = true  # Mark as completed
		
		# Move to next quest if available
		if current_quest_index + 1 < quests.size():
			current_quest_index += 1
			start_current_quest()
		else:
			fade_and_update_text("All quests completed!")  # Apply fade effect
	else:
		fade_and_update_text("Error: Quest not found.")  # Show error

# Function to handle fade animations and update UI text
func fade_and_update_text(new_text: String) -> void:
	if quest_data_display_label:
		var tween = create_tween()
		tween.tween_property(quest_data_display_label, "modulate:a", 0.0, 0.5) # Fade out
		await tween.finished
		quest_data_display_label.text = new_text
		tween = create_tween()
		tween.tween_property(quest_data_display_label, "modulate:a", 1.0, 0.5) # Fade in
