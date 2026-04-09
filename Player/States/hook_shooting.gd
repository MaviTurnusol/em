extends State

func PhysicsProcess(_delta):
	stateOwner.velocity = lerp(stateOwner.velocity, Vector2.ZERO, 0.1)
	
	stateOwner.move_and_slide()
