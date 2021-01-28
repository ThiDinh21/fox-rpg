extends Node2D

func play_grass_effect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")		
	var grassEffect = GrassEffect.instance()
#		var world = get_tree().current_scene
	get_parent().add_child(grassEffect)
	grassEffect.position = position

func _on_Hurtbox_area_entered(_area):
	play_grass_effect()
	queue_free()
