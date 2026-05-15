extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.dashes += 30
		queue_free()
	pass # Replace with function body.
