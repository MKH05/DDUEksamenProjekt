extends StaticBody2D

signal update

var player = null

var rarity_points = {
	"common": Vector2i(1, 3),
	"uncommon": Vector2i(3, 5),
	"rare": Vector2i(6, 10),
	"legendary": Vector2i(12, 20),
	"mythic": Vector2i(25, 40)
}

func _ready() -> void:
	randomize()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		var points = await player.invt.recycle_all(rarity_points, get_tree())
		print("Player scored: ", points, " points!")

		update.emit()
