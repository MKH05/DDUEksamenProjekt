extends Control

@onready var gimal9 = get_node("../Gima-l9")
@onready var space = get_node("../Space")
@onready var speed_lines = get_node("../SpeedLines")
@onready var color_rect = get_node("../WhiteScreen")

@onready var warpsfx = get_node("../WarpSFX")
@onready var warpsfx2 = get_node("../WarpSFX2")

@onready var screen_center = Vector2(get_viewport().get_size().x / 2, get_viewport().get_size().y / 2)
@onready var target_scale = Vector2(2, 2)

@onready var duration = 5
@onready var tween_trans = Tween.TRANS_QUAD
@onready var tween_ease = Tween.EASE_OUT

func _on_start_button_pressed() -> void:
	if speed_lines and speed_lines.material is ShaderMaterial:
		speed_lines.visible = true
		
		warpsfx.play()
		
		var tween1 = create_tween();
		var tween2 = create_tween();
		var tween3 = create_tween();
		var tween4 = create_tween();
		var tween5 = create_tween();
		
		tween1.tween_method(
  			func(value): speed_lines.material.set_shader_parameter("center_radius", value),  
  			0.0,
  			1.0,
  			duration,
		).set_trans(tween_trans).set_ease(tween_ease)
		
		tween2.tween_method(
 			func(value): speed_lines.material.set_shader_parameter("center", value),  
 			Vector2(0.75,0.375),
 			Vector2(0.5,0.5),
  			duration,
		).set_trans(tween_trans).set_ease(tween_ease)
		
		tween3.tween_property(gimal9, 
			"position",
			screen_center,
			duration,
		).set_trans(tween_trans).set_ease(tween_ease)
		
		tween4.tween_property(gimal9, 
			"scale",
			target_scale,
			duration,
		).set_trans(tween_trans).set_ease(tween_ease)
		
		tween3.tween_property(gimal9, 
			"position",
			screen_center,
			duration-4.5,
		).set_trans(tween_trans).set_ease(tween_ease)
		
		tween4.tween_property(gimal9, 
			"scale",
			target_scale*8,
			duration-4.5,
		).set_trans(tween_trans).set_ease(tween_ease)
		
		await tween2.finished
		
		warpsfx2.play()
		
		await tween4.finished
		
		if color_rect:
			color_rect.visible = true
			tween5 = create_tween()
			tween5.tween_property(color_rect, "modulate:a", 1.0, float(duration)/4.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		
		await tween5.finished
		
