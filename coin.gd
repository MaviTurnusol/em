extends Node2D

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
signal item_collected
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		UnlimitedRulebook.coin += 1
		UnlimitedRulebook.score += 10
		item_collected.emit()
		queue_free()
