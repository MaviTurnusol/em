extends Node2D

var active = true

func _ready() -> void:
	UnlimitedRulebook.death.connect(_on_player_death)

func _process(_delta: float) -> void:
	if active:
		$orb.visible = true
		$flash.visible = true
		$glow.visible = true
	else:
		$orb.visible = false
		$flash.visible = false
		$glow.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !active:
		return
		
	if body.is_in_group("Player"):
		body.dashes += 3
		$AudioStreamPlayer2D.play()
		active = false
		var cumplosion = load("res://Objects/dash_explosion.tscn").instantiate()
		add_child(cumplosion)
		UnlimitedRulebook.frameFreeze(0.1, 0.2)
	pass # Replace with function body.

func _on_player_death():
	active = true
