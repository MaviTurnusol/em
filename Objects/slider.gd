extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	object_spawn()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func object_spawn():
	for cell_pos in get_used_cells():
		var tile_data = get_cell_tile_data(cell_pos)
		if tile_data.get_custom_data("type") == "start":
			var slider_obj = load("res://Objects/slider_object.tscn").instantiate()
			slider_obj.slider_pos = tile_data.get_custom_data("slider_pos")
			slider_obj.start_pos = to_global(map_to_local(cell_pos))
			
			var end_pos = null
			var i = 1
			while end_pos == null:
				var tile_dataa = get_cell_tile_data(cell_pos + Vector2i(0, i))
				if tile_dataa.get_custom_data("type") == "end":
					end_pos = to_global(map_to_local(cell_pos + Vector2i(0, i))) - Vector2(0, 16)
				else:
					i += 1
			
			slider_obj.end_pos = end_pos
			slider_obj.global_position = slider_obj.start_pos
			add_child(slider_obj)
	pass
