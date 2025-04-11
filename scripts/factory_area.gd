extends StaticBody2D

var player_in_area: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		print("Player entered the area")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		print("Player exited the area")
