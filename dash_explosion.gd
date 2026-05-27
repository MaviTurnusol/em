extends Node2D

var particle_count = 20
var radius = -2

func _ready() -> void:
	cum()
func _on_timer_timeout() -> void:
	queue_free()

func cum():
	for i in particle_count:
		var sperm = load("res://Objects/sperm.tscn").instantiate()
		var rot = randf_range(-180.0, 180.0)
		sperm.angle_min = rot
		sperm.angle_max = rot
		sperm.rotation_degrees = 180.0-rot
		sperm.global_position.x += cos(deg_to_rad(rot)) * radius
		sperm.global_position.y += sin(deg_to_rad(rot)) * -radius
		add_child(sperm)
