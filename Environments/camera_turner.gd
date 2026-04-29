extends Node

@export var cam : Camera3D
var initialPos : Vector3

func _ready() -> void:
	initialPos = cam.position
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("misc"):
		_turn_right()

func _turn_right():
	var newRot = Vector3(cam.rotation.x, cam.rotation.y + PI/2, cam.rotation.z)
	var newPos = Vector3(cam.position.z, cam.position.y, -cam.position.x)
	
	var twinkRot = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	var twinkPos = get_tree().create_tween()
	twinkRot.tween_property(cam, "rotation", newRot, 0.5)
	twinkPos.tween_property(cam, "position", newPos, 0.5)
	pass
