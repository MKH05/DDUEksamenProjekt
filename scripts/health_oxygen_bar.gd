extends Node

@onready var oxygen_bar = $oxygen_bar
@onready var health_bar = $health_bar

func _process(delta):
	oxygen_bar.value = Globals.player_o2
	health_bar.value = Globals.player_health
