extends StaticBody2D

@export var item: InvItem
var player = null

var trash_items = [
	# Common
	{"name": "Broken glass cup", "rarity": "common"},
	{"name": "Cardboard box", "rarity": "common"},
	{"name": "Glass bottle", "rarity": "common"},
	{"name": "Glass jar", "rarity": "common"},
	{"name": "Newspaper stack", "rarity": "common"},
	{"name": "Old paper", "rarity": "common"},
	{"name": "Plastic jug", "rarity": "common"},
	{"name": "Plastic junk", "rarity": "common"},
	{"name": "Red plastic scrap", "rarity": "common"},
	{"name": "Rubbish bag", "rarity": "common"},
	{"name": "Rusty scrap", "rarity": "common"},
	{"name": "Soda can", "rarity": "common"},
	{"name": "Tin can", "rarity": "common"},
	{"name": "Tuna can", "rarity": "common"},
	{"name": "Vandflaske", "rarity": "common"},

	# Rare
	{"name": "Gold Scrap", "rarity": "rare"},
	{"name": "Metal Scrap", "rarity": "rare"},

	# Legendary
	{"name": "Platinum scrap", "rarity": "legendary"},
	{"name": "Broken tablet", "rarity": "legendary"},

	# Mythic
	{"name": "matthew pixel", "rarity": "mythic"},
	{"name": "mikkel pixel", "rarity": "mythic"},
	{"name": "emilie pixel", "rarity": "mythic"},
	{"name": "callum pixel", "rarity": "mythic"},
	{"name": "cat cardboard box", "rarity": "mythic"}
]

var rarity_weights = {
	"common": 59,
	"uncommon": 25,
	"rare": 10,
	"legendary": 5,
	"mythic": 1
}

func _ready():
	randomize()
	var selected_item = get_random_trash()
	print("Random trash: ", selected_item)

func get_random_trash() -> String:
	var weighted_list = []
	for trash in trash_items:
		var weight = rarity_weights.get(trash.rarity, 1)
		for i in weight:
			weighted_list.append(trash.name)
	if weighted_list.size() > 0:
		return weighted_list[randi() % weighted_list.size()]
	else:
		return "No trash found"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		playercollect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	player.collect(item)
