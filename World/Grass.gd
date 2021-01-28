extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func play_grass_effect():	
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.position = position

func _on_Hurtbox_area_entered(_area):
	play_grass_effect()
	queue_free()
