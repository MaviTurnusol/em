extends StaticBody2D

class_name Door

func unlock():
	$AnimatedSprite2D.play("default")
	$CollisionShape2D.set_deferred("disabled", true)

func lock():
	$AnimatedSprite2D.play_backwards("default")
	$CollisionShape2D.set_deferred("disabled", false)
