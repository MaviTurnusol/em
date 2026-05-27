extends Node2D

var dashes = 0 : set = set_dashes
var sprites = []

func set_dashes(value):
	if value == dashes:
		return
	if value < dashes:
		var deleteQueuedSprites = []
		for spriteIndex in dashes - value:
			var lastSprite = sprites.pop_back()
			deleteQueuedSprites.append(lastSprite)
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			twink.tween_property(lastSprite, "position", Vector2.ZERO, 0.33)
			twink.tween_callback(lastSprite.queue_free)
		#for sprite in deleteQueuedSprites:
			#if sprite:
				#sprite.queue_free()
	if value > dashes:
		for i in value - dashes:
			var sprite = Sprite2D.new()
			sprite.texture = load("res://Objects/dashThingy.png")
			add_child(sprite)
			sprites.append(sprite)
	dashes = value
		
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation_degrees += delta * 60.0
	dashes = UnlimitedRulebook.player.dashes
	for spriteIndex in sprites.size():
		var alpha = (float(spriteIndex)/sprites.size())*(2*PI)
		sprites[spriteIndex].position.x = lerp(sprites[spriteIndex].position.x, cos(alpha)*22.5, 0.5)
		sprites[spriteIndex].position.y = lerp(sprites[spriteIndex].position.y, sin(alpha)*22.5, 0.5)
	pass
