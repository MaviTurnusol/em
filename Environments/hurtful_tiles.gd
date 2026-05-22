extends TileMapLayer

var glitch_shader = preload("res://glitch.gdshader")

func _ready() -> void:
	add_glitch()

func add_glitch():
	var used_rect = get_used_rect()
	var tile_size = 16 # Tile boyutunu değişkene almak ileride değiştirmeyi kolaylaştırır
	
	# Konumları da artık tile_size (16) ile çarpıyoruz:
	$ColorRect.position = used_rect.position * tile_size - Vector2i(1, 1)
	$ColorRect.size = used_rect.size * tile_size + Vector2i(2, 2)
	
	$Hue.position = used_rect.position * tile_size - Vector2i(1, 1)
	$Hue.size = used_rect.size * tile_size + Vector2i(2, 2)
