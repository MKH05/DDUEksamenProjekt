extends CharacterBody2D

const SPEED = 500.0
const SPRINT_SPEED = 750.0
const ACCEL = 5.0

var is_sprinting = false
var last_direction = Vector2.ZERO  

@export var invt: inv
@onready var animations = $AnimationPlayer

func _ready() -> void:
	var color_rect = $WhiteScreen
	var tween = create_tween()
	
	if color_rect:
		color_rect.visible = true
		tween.tween_property(color_rect, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func get_input() -> Vector2:
	var new_input = Vector2.ZERO
	new_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	new_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if new_input.length() > 1:
		new_input = new_input.normalized()

	if new_input != Vector2.ZERO:
		last_direction = new_input

	return new_input

func update_animation():
	var direction = ""

	if abs(last_direction.x) > 0.5 and abs(last_direction.y) > 0.5:
		if last_direction.x > 0 and last_direction.y > 0:
			direction = "DiagDownRight"
		elif last_direction.x > 0 and last_direction.y < 0:
			direction = "DiagUpRight"
		elif last_direction.x < 0 and last_direction.y > 0:
			direction = "DiagDownLeft"
		elif last_direction.x < 0 and last_direction.y < 0:
			direction = "DiagUpLeft"
	else:
		if abs(last_direction.x) > abs(last_direction.y):
			direction = "Right" if last_direction.x > 0 else "Left"
		else:
			direction = "Down" if last_direction.y > 0 else "Up"

	if velocity.length() == 0:
		animations.play("Idle" + direction)
	else:
		animations.play("Walk" + direction)

func _physics_process(delta):
	var player_input = get_input()
	is_sprinting = Input.is_action_pressed("sprint")
	var current_speed = SPRINT_SPEED if is_sprinting else SPEED
	
	if player_input != Vector2.ZERO:
		velocity = lerp(velocity, player_input * current_speed, delta * ACCEL)
	else:
		velocity = Vector2.ZERO
	
	update_animation()
	move_and_slide()

func player():
	pass

func collect(item):
	if invt.insert(item):
		return true
	else:
		return false
