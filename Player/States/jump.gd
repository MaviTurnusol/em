extends State

func Start():
	$jumpSounds.play()
	stateOwner.velocity.y = stateOwner.jumpVelocity

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	if stateOwner.velocity.y > -1.0:
		machine.change_state_to("fall")
	
	if Input.is_action_just_released("jump"):
		stateOwner.velocity.y *= 0.6
