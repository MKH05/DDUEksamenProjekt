extends StaticBody2D

signal update

var player = null

var rarity_points = {
	"common": 1,
	"uncommon": 3,
	"rare": 7,
	"legendary": 15,
	"mythic": 30
}

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		var total_points = 0

		for slot in player.invt.slots:
			if slot.item != null and slot.amount > 0:
				var rarity = slot.item.rarity
				var points_per_item = rarity_points.get(rarity, 0)
				total_points += points_per_item * slot.amount

				slot.item = null
				slot.amount = 0

		update.emit()
		print("Player scored: ", total_points, " points!")
		update.emit()
