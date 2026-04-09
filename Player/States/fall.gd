extends State

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	if stateOwner.is_on_floor():
		machine.change_state_to("idle")
