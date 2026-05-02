extends TileMapLayer

var glitch_shader = preload("res://glitch.gdshader")
func _ready() -> void:
	add_glitch()
	pass # Replace with function body.

func add_glitch():
	$ColorRect.size = get_used_rect().size * 16 + Vector2i(2, 2)
	$ColorRect.position = get_used_rect().position - Vector2i(1, 1)
	
	$Hue.size = get_used_rect().size * 16 + Vector2i(2, 2)
	$Hue.position = get_used_rect().position - Vector2i(1, 1)
	pass
