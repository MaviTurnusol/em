extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_button_pressed)
	$AudioStreamPlayer2D.play()
func _on_start_button_pressed():
	$VBoxContainer/StartButton.disabled = true
	$VBoxContainer/ExitButton.disabled = true
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Common/stage_father_the_primordial_one.tscn")
	
func _on_exit_button_pressed():
	get_tree().quit()
