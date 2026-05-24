extends AnimationPlayer

func _on_dialogue_label_started_typing() -> void:
	play("shake")
	pass # Replace with function body.


func _on_dialogue_label_finished_typing() -> void:
	play("RESET")
	pass # Replace with function body.
