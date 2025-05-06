extends StaticBody2D

signal update

var player = null
var is_on_cooldown = false

@onready var sound_effect = $AudioStreamPlayer2D
@onready var timer = $Timer

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
	if is_on_cooldown:
		return
	
	if body.has_method("player"):
		is_on_cooldown = true
		
		player = body
		
		var points = await player.invt.recycle_all(rarity_points, get_tree(), Callable(self, "play_sound"))
		points *= Globals.upgrade_mult
		Globals.points += points
		
		print("Player scored: ", points, " points!", " ", "Total points: ", Globals.points, " points!")
		
		Globals.reused -= points
		points = 0
		
		update.emit()
		
		timer.start()
		await timer.timeout
		
		is_on_cooldown = false

func play_sound(pitch: float) -> void:
	sound_effect.pitch_scale = pitch
	sound_effect.play()
