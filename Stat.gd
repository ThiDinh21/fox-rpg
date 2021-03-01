extends Node

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_changed(val)
signal max_health_changed(val)

func set_health(val):
	health = val
	emit_signal("health_changed", health)
	if health <= 0:
		health = 0
		emit_signal("no_health")
		
func set_max_health(val):
	max_health = val
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func _ready():
	self.health = max_health
