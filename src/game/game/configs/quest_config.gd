extends Resource
class_name QuestConfig

# Enum listing all quest keys (matching order in QUESTS)
enum QuestKeys {
	GatherItems,
	OpenInventory,
	WeaveRope,
	CraftWoodenAxe,
	ChopTree,
	GatherFruit,
	EatSomething,
	CraftWoodenPickAxe,
	MineSomething,
	HuntAnimal,
	BuildCampfire,
	CookMeat,
	CraftTorch,
	BuildTent,
	BuildRaft
}

# List of quests with corresponding events
const QUESTS := [
	{ "key": QuestKeys.GatherItems, "text": "Pick up some stones, sticks or plants for crafting. (Press E to pick up items from the ground)" },
	{ "key": QuestKeys.OpenInventory, "text": "Open your inventory. (Press TAB to access your items and crafting menu)" },
	{ "key": QuestKeys.WeaveRope, "text": "Make rope from plant fibers. (Craft it using gathered plants in your inventory)" },
	{ "key": QuestKeys.CraftWoodenAxe, "text": "Craft a wooden axe. (Press TAB to open the inventory and crafting)" },
	{ "key": QuestKeys.ChopTree, "text": "Chop down a tree to collect wood. (Equip the crafted axe in the hotbar, switch the active slot by pressing the corresponding 1-9 key, and press Left-Click near a tree)" },
	{ "key": QuestKeys.GatherFruit, "text": "Pick up some fruits. (Press E to pick up fruits from a bush)" },
	{ "key": QuestKeys.EatSomething, "text": "Eat something to restore health and energy. (Equip food in a hotbar slot, switch the active slot by pressing the corresponding 1-9 key, and press Left-Click to eat)" },
	{ "key": QuestKeys.CraftWoodenPickAxe, "text": "Craft a wooden pickaxe. (Press TAB to open the inventory and crafting)" },
	{ "key": QuestKeys.MineSomething, "text": "Mine a coal boulder to get coal. (Use a crafted pickaxe and press Left-Click near a coal boulder)" },
	{ "key": QuestKeys.HuntAnimal, "text": "Hunt an animal for food. (Equip a tool in the hotbar, switch the active slot by pressing the corresponding 1-9 key, and press Left-Click near an animal)" },
	{ "key": QuestKeys.BuildCampfire, "text": "Build a campfire to cook food. (Press TAB to open the inventory and crafting. Then equip it in the hotbar, switch the active slot by pressing the corresponding 1-9 key, and press Left-Click to place it)" },
	{ "key": QuestKeys.CookMeat, "text": "Cook meat over a fire. (Interact using E and then equip raw meat to cook)" },
	{ "key": QuestKeys.CraftTorch, "text": "Craft a torch to see in the dark. (Find materials and craft it from the inventory menu)" },
	{ "key": QuestKeys.BuildTent, "text": "Build a tent to rest safely. (Press TAB to open the inventory and crafting. Then equip it in the hotbar, switch the active slot by pressing the corresponding 1-9 key, and press Left-Click to place it)" },
	{ "key": QuestKeys.BuildRaft, "text": "Build a raft to cross water. (Press TAB to open the inventory and crafting. Then equip it in the hotbar, switch the active slot by pressing the corresponding 1-9 key, and press Left-Click to place it)" }	
]

# Function to get a quest by key
static func get_quest_by_key(key: QuestKeys):
	for quest in QUESTS:
		if quest["key"] == key:
			return quest
	return null
