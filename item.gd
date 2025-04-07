extends StaticBody2D

@export var item: InvItem
@export var point: int
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

var point_range = {
	"common": {"min": 1, "max": 2},
	"uncommon": {"min": 3, "max": 6},
	"rare": {"min": 10, "max": 15},
	"legendary": {"min": 20, "max": 40},
	"mythic": {"min": 100, "max": 200}
}

func _ready():
	randomize()
	var selected_item = get_random_trash()
	item = InvItem.new()
	item.name = selected_item.name
	
	var image_path = "res://assets/trash/" + selected_item.name + ".png"
	var texture = load(image_path)

	if texture is Texture:
		print("Loaded image for: ", selected_item.name)
		item.texture = texture
		$Sprite2D.texture = texture
	
	var range = point_range.get(selected_item.rarity, {"min": 0, "max": 0})
	point = randi() % (range.max - range.min + 1) + range.min
	print("Selected item: ", selected_item.name, " | Rarity: ", selected_item.rarity, " | Points: ", point)

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
		await get_tree().create_timer(0.1).timeout
		self.queue_free()

func playercollect():
	player.collect(item)
