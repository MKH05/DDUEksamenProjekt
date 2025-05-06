extends StaticBody2D

@onready var color_rect = $ColorRect
@onready var color_rect2 = $ColorRect2

@onready var rec_label = $ColorRect/Label
@onready var rec_cost_label = $ColorRect/Label2

@onready var up_label = $ColorRect2/Label
@onready var up_cost_label = $ColorRect2/Label2

@onready var timer = $Timer

var is_on_cooldown = false
var player = null

var rec := 1
var rec_level_cost := 100

var up := 1
var up_level_cost := 100

func _ready() -> void:
	_update_ui()

func _on_area_2d_body_entered(body: Node2D) -> void:
	_update_ui()
	
	if is_on_cooldown:
		return

	is_on_cooldown = true
	color_rect.color = Color("#ffa59629")
	player = body
	
	_buy_rec_level()
	
	timer.start()
	await timer.timeout
	
	color_rect.color = Color("#10e80e29")
	is_on_cooldown = false

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	_update_ui()
	
	if is_on_cooldown:
		return

	is_on_cooldown = true
	color_rect2.color = Color("#ffa59629")
	player = body
	
	_buy_up_level()
	
	timer.start()
	await timer.timeout
	
	color_rect2.color = Color("#10e80e29")
	is_on_cooldown = false

func _update_ui() -> void:
	rec_label.text = "Upgrade Recycler (" + str(rec) + ")"  
	rec_cost_label.text = "Cost: " + str(rec_level_cost) 

	up_label.text = "Upgrade Upgrader (" + str(up) + ")"
	up_cost_label.text = "Cost: " + str(up_level_cost) 
	
func _buy_rec_level() -> void:
	if Globals.money >= rec_level_cost:
		Globals.money -= rec_level_cost
		rec += 1
		rec_level_cost = int(rec_level_cost * 1.5)
		_update_ui()

func _buy_up_level() -> void:
	if Globals.money >= up_level_cost:
		Globals.money -= up_level_cost
		Globals.upgrade_mult += 0.1
		up += 1
		up_level_cost = int(up_level_cost * 1.5)
		_update_ui()
