extends CharacterBody2D

var slider_pos : Vector2 = Vector2(0, 0)
var start_pos : Vector2
var end_pos : Vector2

var move_down = false

func _ready() -> void:
	#$StaticBody2D/Sprite2D.position = slider_pos
	pass
	
func _physics_process(_delta: float) -> void:
	if move_down:
		if UnlimitedRulebook.player:
			if is_instance_valid(UnlimitedRulebook.player):
				if global_position.y < end_pos.y:
					velocity.y = clamp(UnlimitedRulebook.player.velocity.y, 0, 200.0)
	else:
		if global_position.y > start_pos.y:
			velocity.y = lerp(velocity.y, -200.0, 0.01)
			velocity.y = clamp(velocity.y, -1000.0, 0.0)
			
	if global_position.y < start_pos.y:
		velocity.y = 0
		global_position.y = start_pos.y
	if global_position.y > end_pos.y:
		velocity.y = 0
		global_position.y = end_pos.y
	
	velocity.x = 0
	position.x = start_pos.x
	move_and_slide()
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		move_down = true
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		move_down = false
		velocity.y = 0.0
