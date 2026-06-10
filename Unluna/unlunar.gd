extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if $Skeleton2D/Segment.global_position.distance_to(UnlimitedRulebook.player.global_position) > 100.0:
		$Skeleton2D/Segment.global_position = lerp($Skeleton2D/Segment.global_position, UnlimitedRulebook.player.global_position - Vector2(0, 40), 0.01)
	$Movers/HeadTarget.global_position = lerp($Movers/HeadTarget.global_position, UnlimitedRulebook.player.global_position, 0.3)
	#$Skeleton2D/Segment.global_position = lerp($Skeleton2D/Segment.global_position, UnlimitedRulebook.player.global_position, 0.01)
	pass
