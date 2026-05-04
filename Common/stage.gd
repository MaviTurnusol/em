extends Area2D

class_name Stage

@export var initial_stage := false

@export var right_stage : String
@export var left_stage : String
@export var top_stage : String
@export var bottom_stage : String

@export var collision_shape : CollisionShape2D

var adjacent_stages : Array

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
	if right_stage:
		adjacent_stages.append(right_stage)
	if left_stage:
		adjacent_stages.append(left_stage)
	if top_stage:
		adjacent_stages.append(top_stage)
	if bottom_stage:
		adjacent_stages.append(bottom_stage)
	
	if initial_stage:
		load_adjacent_stages()
		tween_camera_borders()
		
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		UnlimitedRulebook.current_stage = name
		load_adjacent_stages()
		tween_camera_borders()

func load_adjacent_stages():
	for stage in adjacent_stages:
		if get_tree().root.get_child(0).has_node("/root/StageFatherThePrimordialOne/"+stage):
			print("cockandballsz")
			break
		var newStage = load("res://Environments/Stages/" + stage + ".tscn").instantiate()
		match stage:
			top_stage:
				newStage.global_position = global_position + Vector2(0, 
				-newStage.collision_shape.shape.size.y)
			bottom_stage:
				newStage.global_position = global_position + Vector2(0, 
				collision_shape.shape.size.y)
			right_stage:
				newStage.global_position = global_position + Vector2(collision_shape.shape.size.x, 
				0)
			left_stage:
				newStage.global_position = global_position + Vector2(-newStage.collision_shape.shape.size.x, 
				0)
		#get_parent().add_child(newStage)
		get_parent().call_deferred("add_child", newStage)
		print("ballbasar")

func unload_adjacent_stages():
	for stage in adjacent_stages:
		if UnlimitedRulebook.current_stage != stage:
			get_parent().get_node(stage).queue_free()

func tween_camera_borders():
	var lefttween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	var righttween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	var toptween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	var bottomtween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	lefttween.tween_property(UnlimitedRulebook.cam, "limit_left", global_position.x, 0.5)
	righttween.tween_property(UnlimitedRulebook.cam, "limit_right", global_position.x + collision_shape.shape.size.x, 0.5)
	toptween.tween_property(UnlimitedRulebook.cam, "limit_top", global_position.y, 0.5)
	bottomtween.tween_property(UnlimitedRulebook.cam, "limit_bottom", global_position.y + collision_shape.shape.size.y, 0.5)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#UnlimitedRulebook.current_stage = null
		#unload_adjacent_stages()
		if left_stage == "" && UnlimitedRulebook.player.global_position.x < global_position.x:
			UnlimitedRulebook.player.death()
		if right_stage == "" && UnlimitedRulebook.player.global_position.x > global_position.x + collision_shape.shape.size.x:
			UnlimitedRulebook.player.death()
		if top_stage == "" && UnlimitedRulebook.player.global_position.y < global_position.y:
			UnlimitedRulebook.player.death()
		if bottom_stage == "" && UnlimitedRulebook.player.global_position.y > global_position.y + collision_shape.shape.size.y:
			UnlimitedRulebook.player.death()
		#if UnlimitedRulebook.current_stage == null:
			#UnlimitedRulebook.player.death()
