extends Node

var item_scene : PackedScene
var spawn_timer : Timer
var max_items : int = 1000

func _ready():
	item_scene = load("res://inventory/items/Item.tscn") 

func _process(delta):
	if get_child_count() < max_items:
		spawn_item()

func spawn_item():
	var item_instance = item_scene.instantiate()
	var random_position = Vector2(randf_range(-25000, 25000), randf_range(-25000, 25000))
	item_instance.position = random_position
	item_instance.z_index = 1
	add_child(item_instance)
