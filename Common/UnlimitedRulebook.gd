extends Node

var player
var cam
var current_stage

#signals
signal death

#This is a coin gain/up mechanic
var coin = 0
var score = 0

var checkpoint := Vector2(0, 0)

func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await get_tree().create_timer(timeScale * duration).timeout
	OS.delay_msec(5)
	Engine.time_scale = 1.0

func set_movable(foo: bool):
	if player:
		if is_instance_valid(player):
			player.can_input = foo
			if foo == false:
				player.machine.change_state_to("idle")
