extends PathFollow2D

var speed = 130.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#progress += delta * speed
	progress_ratio += delta * 0.2
	if progress_ratio < 0.5:
		$StaticBody2D/AnimatedSprite2D.flip_h = false
	else:
		$StaticBody2D/AnimatedSprite2D.flip_h = true
