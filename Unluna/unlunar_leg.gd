extends Skeleton2D

var rayCastFan : Array = []
var currentCollisions : Array = []
var targetPos : Vector2

func _ready() -> void:
	targetPos = $Target.global_position
	for i in 12:
		var rayCast = RayCast2D.new()
		rayCast.target_position = Vector2(0.0, 88.0)
		rayCast.rotation_degrees = (360.0/12.0)*i
		rayCast.collision_mask = 6
		rayCast.set_collision_mask_value(6, true)
		add_child(rayCast)
		rayCastFan.append(rayCast)

func _on_check_impact_points_timeout() -> void:
	currentCollisions = []
	var closestCollisionPoint = Vector2(-99999, -99999)
	for raycast in rayCastFan:
		if raycast is RayCast2D:
			if raycast.is_colliding():
				var collision = raycast.get_collision_point()
				currentCollisions.append(collision)
				
				if closestCollisionPoint == Vector2(-99999, -99999):
					closestCollisionPoint = collision
					continue
				
				if collision.distance_to(UnlimitedRulebook.player.global_position) < closestCollisionPoint.distance_to(UnlimitedRulebook.player.global_position):
					closestCollisionPoint = collision
	if currentCollisions.is_empty():
		return
	targetPos = closestCollisionPoint
	
	var alpha = $Target.global_position.angle_to_point(targetPos) + PI/2
	var alphangle = Vector2(cos(alpha)*50, sin(alpha)*50)
	var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	#twink.tween_property($Target, "global_position", targetPos + alphangle, 0.24)
	
	twink.tween_property($Target, "global_position", targetPos, 0.49)
	#$checkImpactPoints.start(randf_range(0.21, 0.4))
