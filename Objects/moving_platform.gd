extends PathFollow2D

var is_player_on = false

func _process(_delta: float) -> void:
	$AnimatableBody2D/AnimatedSprite2D.speed_scale = (0.5 - abs(0.5 - progress_ratio))*2.0
	#0.0 -> 0.0
	#0.1 -> 0.1
	#0.5 -> 1.0
	#0.9 -> 0.1
	#1.0 -> 0.0
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_on = true
		$AnimationPlayer.play("progress")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_on = false
		$AnimationPlayer.play_backwards("progress")
