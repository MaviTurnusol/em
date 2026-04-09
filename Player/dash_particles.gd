extends Node2D

var dir := Vector2(0, -1)
var dashDuration = 0.33
func _ready():
	$floating.emitting = true
	$floating2.emitting = true
	
	$floating.process_material.set("shader_parameter/active", false)
	$floating.process_material.set("shader_parameter/direction", Vector3(-dir.x, -dir.y, 0))
	
	$floating2.process_material.set("shader_parameter/active", false)
	$floating2.process_material.set("shader_parameter/direction", Vector3(-dir.x, -dir.y, 0))
	
	$Timer.start(dashDuration*1/2)
	$Timer2.start(dashDuration)
	
func _on_timer_timeout():
	$floating.process_material.set("shader_parameter/active", true)
	$floating2.process_material.set("shader_parameter/active", true)
	pass

func _on_timer_2_timeout():
	$floating.process_material.set("shader_parameter/active", false)
	$floating2.process_material.set("shader_parameter/active", false)
	queue_free()
