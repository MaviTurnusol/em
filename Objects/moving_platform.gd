extends PathFollow2D

var is_player_on = false
@export var speed_cap = 320.0
@export var acceleration = 2.0
var speed := 0.0

var lastPosition := Vector2.ZERO
var velocity := Vector2.ZERO
var lastMovingVelocity := Vector2.ZERO

var path : Path2D

func _ready() -> void:
	lastPosition = $AnimatableBody2D.global_position
	$AnimationPlayer.speed_scale = speed
	path = get_parent()
	
func _process(delta: float) -> void:
	if is_player_on:
		if progress_ratio < 0.99:
			speed = clamp(speed + delta*speed_cap*acceleration, -speed_cap, speed_cap)
			progress = clamp(progress + speed*delta, 0.0, path.curve.get_baked_length()-0.5)
		else:
			speed = 0.0
		if progress == 0.0:
			speed = 0.0
	else:
		if progress != 0.0:
			speed = clamp(speed - delta*speed_cap*acceleration, -speed_cap, speed_cap)
			progress = clamp(progress + speed*delta, 0.0, path.curve.get_baked_length()-0.5)
		if progress == 0.0:
			speed = 0.0
		if progress_ratio > 0.99:
			speed = 0.0
	
	lastPosition = $AnimatableBody2D.global_position
	#$AnimatableBody2D/AnimatedSprite2D.speed_scale = (0.5 - abs(0.5 - progress_ratio))*2.0
	$AnimatableBody2D/AnimatedSprite2D.speed_scale = speed/300.0
	var velocity_y = (global_position.y - lastPosition.y)/delta
	var velocity_x = (global_position.x - lastPosition.x)/delta
	velocity = Vector2(velocity_x, velocity_y)
	if velocity != Vector2.ZERO:
		lastMovingVelocity = velocity
		$grace.stop()
	else:
		if $grace.is_stopped(): $grace.start()
	$AnimatableBody2D/Label.text = "Velocity.y: " + str(round(lastMovingVelocity.y))
	$AnimatableBody2D/Label2.text = "Velocity.x: " + str(round(lastMovingVelocity.x))
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_on = true
		body.mover = $AnimatableBody2D
		#$AnimationPlayer.play("progress")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_on = false
		body.mover = null
		#$AnimationPlayer.play_backwards("progress")


func _on_grace_timeout() -> void:
	lastMovingVelocity = Vector2.ZERO
	pass # Replace with function body.
