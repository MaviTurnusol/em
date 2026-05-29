extends State

var boost = 60.0

func Start():
	$jumpSounds.play()
	
	stateOwner.velocity.y = stateOwner.jumpVelocity
	
	if stateOwner.mover != null:
		if stateOwner.mover.get_parent().lastMovingVelocity.y < -700.0:
			stateOwner.velocity.y -= boost*2
		if stateOwner.mover.get_parent().lastMovingVelocity.y < -1400.0:
			stateOwner.velocity.y -= boost*4
		if !Input.is_action_pressed("right"):
			if stateOwner.mover.get_parent().lastMovingVelocity.x < -700.0:
				stateOwner.velocity.x -= boost*10
			if stateOwner.mover.get_parent().lastMovingVelocity.x < -1400.0:
				stateOwner.velocity.x -= boost*20
		if !Input.is_action_pressed("left"):
			if stateOwner.mover.get_parent().lastMovingVelocity.x > 700.0:
				stateOwner.velocity.x += boost*10
			if stateOwner.mover.get_parent().lastMovingVelocity.x > 1400.0:
				stateOwner.velocity.x += boost*20
		print(stateOwner.mover.get_parent().lastMovingVelocity)

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	if stateOwner.velocity.y > -1.0:
		machine.change_state_to("fall")
	
	if Input.is_action_just_released("jump"):
		stateOwner.velocity.y *= 0.6
