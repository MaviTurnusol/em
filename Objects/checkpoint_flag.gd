extends Node2D

var state = 0

func _process(_delta: float) -> void:
	$Marker2D/shadow.frame = $Marker2D/AnimatedSprite2D.frame
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if state == 0:
		if body.is_in_group("Player"):
			print("checkpoint got")
			$Marker2D/AnimatedSprite2D.play("green")
			$AnimationPlayer.play("wobble")
			UnlimitedRulebook.checkpoint = global_position
			state = 1
	pass # Replace with function body.
