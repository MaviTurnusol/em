extends Area2D

class_name KeyBaby
var collected = false
var siblings = []
var door
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	siblings.append(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for sibling in get_parent().get_children():
		if sibling is KeyBaby:
			if !siblings.has(sibling):
				siblings.append(sibling)
		if sibling is Door:
			door = sibling
	if check_sibling_collection():
		$AnimationPlayer.play("destroy")
		if door:
			if is_instance_valid(door):
				door.unlock()
	pass

func check_sibling_collection():
	for sibling in siblings:
		if !sibling.collected:
			return false
	return true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.train.append(self)
		$CollisionShape2D.set_deferred("disabled", true)
		collected = true
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "destroy":
		UnlimitedRulebook.player.train.erase(self)
		queue_free()
	pass # Replace with function body.
