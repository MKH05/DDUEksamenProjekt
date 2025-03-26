extends CharacterBody2D

const SPEED = 500.0
const SPRINT_SPEED = 750.0
const ACCEL = 5.0

var input: Vector2 = Vector2.ZERO
var is_sprinting = false

@export var invt: inv
@onready var animations = $AnimationPlayer


func _ready() -> void:
	var color_rect = $WhiteScreen
	var tween = create_tween()
	
	if color_rect:
		color_rect.visible = true
		tween.tween_property(color_rect, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

var last_direction = Vector2.ZERO  # Stores the last valid movement direction

func get_input() -> Vector2:
	var new_input = Vector2.ZERO
	new_input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	new_input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Handle cases where the player changes direction while holding another key
	if new_input.x != 0:
		new_input.y = 0  # Prioritize horizontal movement if pressing both
	elif new_input.y != 0:
		new_input.x = 0  # Prioritize vertical movement if pressing both

	# Update last direction if input is detected
	if new_input != Vector2.ZERO:
		last_direction = new_input.normalized()

	return new_input.normalized()


func updateanimation():
	if velocity.length() == 0:
		animations.stop()
		return  # Stop animations when not moving
	
	var direction = ""

	# Check for diagonal movement first
	if velocity.x > 0 and velocity.y > 0:
		direction = "DiagDownRight"
	elif velocity.x > 0 and velocity.y < 0:
		direction = "DiagUpRight"
	elif velocity.x < 0 and velocity.y > 0:
		direction = "DiagDownLeft"
	elif velocity.x < 0 and velocity.y < 0:
		direction = "DiagUpLeft"
	
	# If not diagonal, check for standard movement
	elif velocity.x < 0:
		direction = "Left"
	elif velocity.x > 0:
		direction = "Right"
	elif velocity.y < 0:
		direction = "Up"
	elif velocity.y > 0:
		direction = "Down"

	animations.play("Walk" + direction)

func _physics_process(delta):
	var playerInput = get_input()
	is_sprinting = Input.is_action_pressed("sprint")
	var current_speed = SPRINT_SPEED if is_sprinting else SPEED
	
	if playerInput != Vector2.ZERO:
		velocity = lerp(velocity, playerInput * current_speed, delta * ACCEL)
	else:
		velocity = Vector2.ZERO
	
	updateanimation()
	
	move_and_slide()
	

func player():
	pass

func collect(item):
	invt.insert(item)
