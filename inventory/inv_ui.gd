extends Control

@onready var Inv: inv = preload("res://inventory/playerinventory.tres")
@onready var slots: Array = $Panel/GridContainer.get_children()

@onready var ReuseBar = $ReuseBar
@onready var HealthBar = $HealthBar
@onready var OxygenBar = $OxygenBar

var is_open = true

func _ready() -> void:
	Inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(Inv.slots.size(),slots.size())):
		slots[i].update(Inv.slots[i])

func _process(_delta: float) -> void:
	update_bars()
	
	if Input.is_action_just_pressed("openinv"):
		if is_open:
			close()
		else:
			open()

func update_bars():
	HealthBar.max_value = Globals.player_max_health
	HealthBar.value = Globals.player_health
	
	var health = Globals.player_health
	var r = abs(health * 0.01 - 1.0)
	var g = health * 0.01
	var b = 0.0
	
	var health_fill: StyleBoxFlat = HealthBar.get("theme_override_styles/fill")
	if health_fill == null:
		health_fill = StyleBoxFlat.new()
		HealthBar.add_theme_stylebox_override("fill", health_fill)
	health_fill.bg_color = Color(r, g, b)
	
	OxygenBar.max_value = Globals.player_max_o2
	OxygenBar.value = Globals.player_o2
	
	var o2_fill: StyleBoxFlat = OxygenBar.get("theme_override_styles/fill")
	if o2_fill == null:
		o2_fill = StyleBoxFlat.new()
		OxygenBar.add_theme_stylebox_override("fill", o2_fill)
	
	var o2_ratio = float(Globals.player_o2) / float(Globals.player_max_o2)
	if o2_ratio < 0.35:
		var flash = sin(Time.get_ticks_msec() / 150.0) > 0.0
		o2_fill.bg_color = Color(1, 0, 0) if flash else Color(0.2, 0.6, 1.0)
	else:
		o2_fill.bg_color = Color(0.2, 0.6, 1.0)
	
	ReuseBar.max_value = 999999999
	ReuseBar.value = Globals.reused
	
	var reuse_fill: StyleBoxFlat = ReuseBar.get("theme_override_styles/fill")
	if reuse_fill == null:
		reuse_fill = StyleBoxFlat.new()
		ReuseBar.add_theme_stylebox_override("fill", reuse_fill)
	reuse_fill.bg_color = Color(0.8, 0.4, 0.0)
	


func open():
	visible = true
	is_open = true
	

func close():
	visible = false
	is_open = false
	
