extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim = $StaticBody2D/AnimatedSprite2D.sprite_frames.get_animation_names().get(randi_range(0, $StaticBody2D/AnimatedSprite2D.sprite_frames.get_animation_names().size()-1))
	$StaticBody2D/AnimatedSprite2D.play(anim)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#$StaticBody2D/button/AnimatedSprite2D.frame = 1
		#$StaticBody2D/button/CollisionShape2D.position.y = -16.5
		
		$AnimationPlayer.pause()
		var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		var twink2 = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		twink.tween_property($StaticBody2D, "position", Vector2(0, 0), 0.2)
		twink2.tween_property($StaticBody2D/button, "position", Vector2(0, 2), 0.2)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#$StaticBody2D/button/AnimatedSprite2D.frame = 0
		#$StaticBody2D/button/CollisionShape2D.position.y = -18.5

		var twink2 = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		twink2.tween_property($StaticBody2D/button, "position", Vector2(0, 0), 0.2)
		
		$AnimationPlayer.stop()
		$AnimationPlayer.play("float")
