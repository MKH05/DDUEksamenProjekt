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
	
	while true:
		Globals.timeplayed += 1
		await get_tree().create_timer(1.0).timeout

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
	
	handle_oxygen_and_health(delta)
	update_animation()
	move_and_slide()

func handle_oxygen_and_health(delta: float) -> void:
	if Globals.player_in_area:
		Globals.player_o2 = min(Globals.player_o2 + 1, Globals.player_max_o2)
	else:
		Globals.player_o2 = max(Globals.player_o2 - 1, 0)
		
		if Globals.player_o2 == 0:
			Globals.player_health = max(Globals.player_health - 0.01, 0)
			
			if Globals.player_health == 0:
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func player():
	pass

func collect(item):
	if invt.insert(item):
		return true
	else:
		return false
