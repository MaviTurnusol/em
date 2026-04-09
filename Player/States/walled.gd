extends State

func Start():
	if stateOwner.get_wall_normal().x == 1.0:
		stateOwner.flip("left")
	if stateOwner.get_wall_normal().x == -1.0:
		stateOwner.flip("right")

func PhysicsProcess(delta):
	stateOwner.move_and_slide()
	
	stateOwner.velocity.y = clamp(stateOwner.velocity.y + 
	stateOwner.get_gravity().y * delta * 0.5, 0, 200)
	
	if !stateOwner.is_on_wall():
		machine.change_state_to("idle")
	
