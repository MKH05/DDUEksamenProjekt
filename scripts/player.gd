extends CharacterBody2D

const SPEED = 1000.0
const SPRINT_SPEED = 1500.0
const ACCEL = 5.0

var input: Vector2 = Vector2.ZERO
var is_sprinting = false

@export var invt: inv

func _ready() -> void:
	var color_rect = $WhiteScreen
	var tween = create_tween()
	
	if color_rect:
		color_rect.visible = true
		tween.tween_property(color_rect, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func get_input() -> Vector2:
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()

func _physics_process(delta):
	var playerInput = get_input()
	is_sprinting = Input.is_action_pressed("sprint")
	var current_speed = SPRINT_SPEED if is_sprinting else SPEED
	
	if playerInput != Vector2.ZERO:
		velocity = lerp(velocity, playerInput * current_speed, delta * ACCEL)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
