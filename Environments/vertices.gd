extends Node3D

var obj
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_vertices()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_vertices():
	var vertices : PackedVector3Array
	for child in obj.get_children():
		if child is Mesh:
			
			for surface in range(child.get_surface_count()):
				var surface_arrays = child.surface_get_arrays(surface)
				
				vertices.append(surface_arrays[Mesh.ARRAY_VERTEX])
	return vertices
