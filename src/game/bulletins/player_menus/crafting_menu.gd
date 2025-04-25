extends PlayerMenuBase

# UI menu for crafting items, displaying available crafting options
# and handling user interactions.

@onready var crafting_button_container: GridContainer = %CraftingButtonContainer  # Container holding crafting buttons
@export var crafting_button_scene: PackedScene  # Scene reference for the crafting button

func _ready() -> void:
	# Populate the crafting menu with available craftable items
	for craftable_item_key in ItemConfig.CRRAFTABLE_ITEM_KEYS:
		var crafting_button := crafting_button_scene.instantiate()  # Create a new crafting button
		crafting_button_container.add_child(crafting_button)  # Add button to the container
		crafting_button.set_item_key(craftable_item_key)  # Assign the item to the button
		
		# Connect button interactions for showing/hiding crafting info and processing crafting actions
		crafting_button.button.mouse_entered.connect(show_crafting_info.bind(crafting_button.item_key))
		crafting_button.button.mouse_exited.connect(hide_crafting_info)
		crafting_button.button.pressed.connect(crafting_button_pressed.bind(crafting_button.item_key))
	
	super()

# Displays crafting information when hovering over a crafting button
func show_crafting_info(item_key: ItemConfig.Keys) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or item_key == null:
		return
	
	var item_resource := ItemConfig.get_item_resource(item_key)
	item_description_label.text = item_resource.display_name + "\n" + item_resource.description
	item_extra_info_label.text = "Requirements:"
	
	# Get crafting blueprint and display required tools and materials
	var blueprint := ItemConfig.get_crafting_blueprint_resource(item_key)
	if blueprint.needs_multitool:
		item_extra_info_label.text += "\nMultitool"
	if blueprint.needs_tinderbox:
		item_extra_info_label.text += "\nTinderbox"
	
	# Display the materials required for crafting
	for cost_resource in blueprint.cost:
		item_extra_info_label.text += "\n%s: %d" % [
			ItemConfig.get_item_resource(cost_resource.item_key).display_name,
			cost_resource.amount
		]

# Clears crafting information when the mouse exits a crafting button
func hide_crafting_info() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	item_description_label.text = ""
	item_extra_info_label.text = ""

# Updates the crafting menu based on the player's inventory
func update_inventory(inventory: Array) -> void:
	super(inventory)
	
	for crafting_button in crafting_button_container.get_children():
		var crafting_blueprint := ItemConfig.get_crafting_blueprint_resource(crafting_button.item_key)
		var disable_button := false  # Determines if crafting should be disabled

		# Check if required tools are available in the inventory
		if crafting_blueprint.needs_multitool and not ItemConfig.Keys.Multitool in inventory:
			disable_button = true
		elif crafting_blueprint.needs_tinderbox and not ItemConfig.Keys.Tinderbox in inventory:
			disable_button = true
		else:
			# Check if required materials are available in the inventory
			for cost_data in crafting_blueprint.cost:
				if inventory.count(cost_data.item_key) < cost_data.amount:
					disable_button = true
					break

		# Enable or disable the crafting button based on resource availability
		crafting_button.button.disabled = disable_button

# Handles crafting when a crafting button is pressed
func crafting_button_pressed(item_key: ItemConfig.Keys) -> void:
	# Remove crafting materials from inventory
	EventSystem.INV_delete_crafting_blueprint_cost.emit(ItemConfig.get_crafting_blueprint_resource(item_key).cost)
	
	# Add crafted item to the inventory
	EventSystem.INV_add_item.emit(item_key)

	# Dynamically build context for AI
	var user_prompt = "Hi how are you"
	# Notify AI agent
	EventSystem.AI_notify_agent_on_user_prompt.emit(user_prompt)

	# Update Quests
	if item_key == ItemConfig.Keys.Rope:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.WeaveRope)
	elif item_key == ItemConfig.Keys.Axe:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.CraftWoodenAxe)
	elif item_key == ItemConfig.Keys.Pickaxe:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.CraftWoodenPickAxe)
	elif item_key == ItemConfig.Keys.Torch:
		EventSystem.QU_quest_finished.emit(QuestConfig.QuestKeys.CraftTorch)

	# Play crafting sound effect
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.Craft)

# Helper function to convert enum to string
func get_item_name_from_key(item_key: ItemConfig.Keys) -> String:
	match item_key:
		ItemConfig.Keys.Axe: return "Axe"
		ItemConfig.Keys.Pickaxe: return "Pickaxe"
		ItemConfig.Keys.Torch: return "Torch"
		ItemConfig.Keys.Rope: return "Rope"
		ItemConfig.Keys.Raft: return "Raft"
		ItemConfig.Keys.Tent: return "Tent"
		ItemConfig.Keys.Campfire: return "Campfire"
		ItemConfig.Keys.Multitool: return "Multitool"
		ItemConfig.Keys.Tinderbox: return "Tinderbox"
		_:
			return "Unknown Item"  # Fallback if the key is not listed
