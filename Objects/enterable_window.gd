extends Control

var on_cooldown = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !on_cooldown:
			var newPlayer = body.duplicate()
			var new_local_pos = body.global_position - $SubViewportContainer.global_position
			newPlayer.global_position = new_local_pos
			$SubViewportContainer/SubViewport.add_child(newPlayer)
			newPlayer.velocity.y *= 0.85
			body.queue_free()
			
			on_cooldown = true
			$cd.start()
	pass # Replace with function body.

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass
func _on_inner_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if !on_cooldown:
			var newPlayer = body.duplicate()
			var new_pos = body.global_position + $SubViewportContainer.global_position
			newPlayer.global_position = new_pos
			get_parent().add_child(newPlayer)
			#newPlayer.machine.change_state_to(body.machine.get_state())
			newPlayer.velocity.y *= 0.85
			body.queue_free()
			
			on_cooldown = true
			$cd.start()
	pass # Replace with function body.

func _on_cd_timeout() -> void:
	on_cooldown = false
	pass # Replace with function body.
