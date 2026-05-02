extends State

var dir := Vector2.ZERO
var dashParticles

func Start():
	stateOwner.set_collision_size("dash")
	
	if Input.is_action_pressed("left"):
		dir = Vector2(-1, 0)
	elif Input.is_action_pressed("right"):
		dir = Vector2(1, 0)
	elif Input.is_action_pressed("up"):
		dir = Vector2(0, -1)
	elif Input.is_action_pressed("down"):
		dir = Vector2(0, 1)
	else:
		dir = Vector2(stateOwner.dir, 0)
	dashParticles = load("res://Player/dash_particles.tscn").instantiate()
	dashParticles.dir = dir
	dashParticles.dashDuration = stateOwner.dashDuration
	stateOwner.add_child(dashParticles)
	$Timer.start(stateOwner.dashDuration)
	
func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	stateOwner.velocity = lerp(stateOwner.velocity, Vector2(400, 400)*dir, 0.5)

func End():
	stateOwner.set_collision_size("default")
	dashParticles.queue_free()
	stateOwner.velocity *= 0.5
	
func _on_timer_timeout():
	machine.change_state_to("idle")
