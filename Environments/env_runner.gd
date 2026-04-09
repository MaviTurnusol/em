extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if UnlimitedRulebook.player:
		if is_instance_valid(UnlimitedRulebook.player):
			$SubViewport2/Camera2D.global_position = Vector2(0, -38) + UnlimitedRulebook.player.global_position
			
