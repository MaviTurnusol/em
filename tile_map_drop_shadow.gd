extends Node2D

@export var map : TileMapLayer

func _ready() -> void:
	if !is_instance_valid(map):
		return
	if map == null:
		return
	
	var newMap = map.duplicate()
	newMap.position += Vector2(4, 4)
	newMap.modulate = Color(0.0, 0.0, 0.0, 0.745)
	newMap.collision_enabled = false
	add_child(newMap)
