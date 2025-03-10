extends Camera2D

@export var follow_strength: float = 0.05

func _process(delta):
	var viewport_size = get_viewport_rect().size
	var mouse_position = get_viewport().get_mouse_position()
	var offset_target = (mouse_position - viewport_size / 2) * follow_strength
	
	offset = offset.lerp(offset_target, delta * 5.0)
