extends Node

@export var marker : Marker3D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("misc"):
		_turn_right()

func _turn_right():
	var markerNewRot = Vector3(marker.rotation.x, marker.rotation.y + PI/2, marker.rotation.z)
	
	var twinkRot = get_tree().create_tween()
	twinkRot.tween_property(marker, "rotation", markerNewRot, 0.5)
	pass
