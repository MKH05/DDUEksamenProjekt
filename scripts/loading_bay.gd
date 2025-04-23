extends StaticBody2D

@onready var color_rect = $ColorRect
@onready var timer = $Timer

var rocket_start_position: Vector2
var is_on_cooldown = false
var player = null

var rocket_tween: Tween = null

func launch_rocket():
	if rocket_tween:
		rocket_tween.kill()
	
	$Rocket.position = rocket_start_position
	
	rocket_tween = create_tween()
	rocket_tween.tween_property($Rocket, "position:y", $Rocket.position.y - 5000, 10.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _ready() -> void:
	rocket_start_position = $Rocket.position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_on_cooldown:
		return
	
	is_on_cooldown = true
	color_rect.color = Color("#ffa59629")
	
	player = body
	
	launch_rocket()
	
	timer.start()
	await timer.timeout
	
	$Rocket.position = rocket_start_position
	
	color_rect.color = Color("#10e80e29")
	is_on_cooldown = false
