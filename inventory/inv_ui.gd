extends Control

@onready var Inv: inv = preload("res://inventory/playerinventory.tres")
@onready var slots: Array = $Panel/GridContainer.get_children()

var is_open = true

func _ready() -> void:
	Inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(Inv.slots.size(),slots.size())):
		slots[i].update(Inv.slots[i])

func _process(_delta: float) -> void:
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
	
