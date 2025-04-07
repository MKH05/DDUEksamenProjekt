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
	{"name": "Soda can", "rarity": "common"},
	{"name": "Vandflaske", "rarity": "common"},

	# Uncommon
	{"name": "Rusty scrap", "rarity": "uncommon"},
	{"name": "Tin can", "rarity": "uncommon"},
	{"name": "Tuna can", "rarity": "uncommon"},

	# Rare
	{"name": "Gold Scrap", "rarity": "rare"},
	{"name": "Metal Scrap", "rarity": "rare"},
	{"name": "Broken tablet", "rarity": "rare"},

	# Legendary
	{"name": "Platinum scrap", "rarity": "legendary"},
	{"name": "Tablet", "rarity": "legendary"},

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

var item_path = "res://inventory/items/"

func _ready():
	randomize()
	var selected_item = get_random_trash()

	var item_resource = load_item_resource(selected_item.name)
	if item_resource:
		item = item_resource

		var image_path = "res://assets/trash/" + selected_item.name + ".png"
		var texture = load(image_path)

		if texture is Texture:
			item.texture = texture
			$Sprite2D.texture = texture
		else:
			print("Image not found for: ", selected_item.name)

	print("Selected item: ", selected_item.name, " | Rarity: ", selected_item.rarity)

func load_item_resource(item_name: String) -> InvItem:
	var resource_path = item_path + item_name + ".tres"
	var item_resource = load(resource_path)

	if item_resource is InvItem:
		return item_resource
	else:
		print("Failed to load resource: ", item_name)
		return null

func get_random_trash() -> Dictionary:
	var weighted_list = []
	for trash in trash_items:
		var weight = rarity_weights.get(trash.rarity, 1)
		for i in weight:
			weighted_list.append(trash)
	if weighted_list.size() > 0:
		return weighted_list[randi() % weighted_list.size()]
	else:
		return {"name": "Unknown", "rarity": "Unknown"}

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		playercollect()

func playercollect():
	if player.collect(item):
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
