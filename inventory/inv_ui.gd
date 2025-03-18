extends Control

@onready var Inv: inv = preload("res://inventory/playerinventory.tres")
@onready var slots: Array = $Panel/GridContainer.get_children()

var is_open = true

func _ready() -> void:
	update_slots()
	close()

func update_slots():
	for i in range(min(Inv.items.size(),slots.size())):
		slots[i].update(Inv.items[i])

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("openinv"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	

func close():
	visible = false
	is_open = false
	
