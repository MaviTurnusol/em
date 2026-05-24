extends Area2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"misc"):
		var actionables = get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
