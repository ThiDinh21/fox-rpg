extends Area2D

func is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if areas.size() > 0:
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position).normalized()
	return push_vector
