extends CharacterBody2D

var speed = 300.0
var jumpVelocity = -400.0
@onready var anima = $Marker2D/anima
@onready var machine = $StateMachine
var dir = 1.0
var dashDuration = 0.2
var onDashCooldown = false

var acceleration = 0.1
var dashes = 0

var inJumpBufferArea = false
var bufferedJump = false

var inWallJumpBufferArea = false
var bufferedWallJump = false
var mover : AnimatableBody2D = null

var can_input = true

var train = []

@export var cam : Camera2D

func _ready():
	UnlimitedRulebook.player = self
	
func _physics_process(delta):
	$DebugLabel.text = str(machine.get_state())
	choo_choo()
	
	if cam:
		if is_instance_valid(cam):
			UnlimitedRulebook.cam = cam
	
	#Dashing
	if can_input:
		if !onDashCooldown:
			if Input.is_action_just_pressed("run"):
				if dashes > 0:
					machine.change_state_to("dash")
					$dashSounds.play()
					$dashCooldown.start()
					dashes -= 1
					onDashCooldown = true
	if is_on_floor():
		dashes = 0
	if dashes > 0:
		$Marker2D/glow.visible = true
	else:
		$Marker2D/glow.visible = false
	
	#Jumping
	if can_input:
		if Input.is_action_just_pressed("jump"):
			if machine.get_state() == "walled":
				velocity.x = get_wall_normal().x * speed*3.2
				if get_wall_normal().x == 1.0:
					flip("right")
				if get_wall_normal().x == -1.0:
					flip("left")
			machine.change_state_to("jump")
		if inJumpBufferArea:
			if Input.is_action_just_pressed("jump"):
				if velocity.y > 0:
					bufferedJump = true
		if bufferedJump:
			if is_on_floor():
				machine.change_state_to("jump")
				bufferedJump = false
			
		if inWallJumpBufferArea:
			if Input.is_action_just_pressed("jump"):
				if !is_on_floor():
					bufferedWallJump = true
					$wallJumpBufferFader.start()
		if bufferedWallJump:
			if machine.get_state() == "walled":
				velocity.x = get_wall_normal().x * speed*3.2
				if get_wall_normal().x == 1.0:
					flip("right")
				if get_wall_normal().x == -1.0:
					flip("left")
				machine.change_state_to("jump")
				bufferedWallJump = false
	
	#After-Images
	if velocity.length() >= 580.0 && $ghostTimer.is_stopped() && machine.get_state() != "idle":
		$ghostTimer.start()
	
	#Falling
	if !is_on_floor() && machine.get_state() not in ["walled", "dash"]:
		#velocity.y += get_gravity().y * delta
		velocity.y = clamp(velocity.y + get_gravity().y * delta, jumpVelocity*2, -jumpVelocity*2)
		if machine.get_state() not in ["roll", "jump"]:
			machine.change_state_to("fall")
	
	#Wall Slide
	if is_on_wall() && velocity.y > -40.0 && !is_on_floor():
		machine.change_state_to("walled")
	
	#Rolling
	if can_input:
		if Input.is_action_just_pressed("misc"):
			machine.change_state_to("roll")
	
	#Walking
	stepper()
	if can_input:
		var dir_ = Input.get_axis("left", "right")
		if machine.get_state() not in ["roll", "dash"]:
			if dir_:
				dir = dir_
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, dir*speed*1.6, acceleration)
					if is_on_floor(): machine.change_state_to("run")
				else:
					velocity.x = lerp(velocity.x, dir*speed, acceleration)
					if is_on_floor(): machine.change_state_to("walk")
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.1)
				if is_on_floor():
					machine.change_state_to("idle")
		
		#Flipping Sprite/Hurtbox
		if machine.get_state() not in ["jump", "fall", "roll"]:
			if Input.is_action_pressed("left"):
				flip("left")
			elif Input.is_action_pressed("right"):
				flip("right")
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)

func flip(foo) -> void:
	match foo:
		"left":
			$Marker2D.scale.x = -1
		"right":
			$Marker2D.scale.x = 1

func death():
	$deathSound.play()
	dashes = 0
	var cumplosion = load("res://Objects/dash_explosion.tscn").instantiate()
	cumplosion.global_position = global_position + Vector2(0, -16)
	cumplosion.radius = -25
	get_tree().root.add_child(cumplosion)
	UnlimitedRulebook.frameFreeze(0.1, 0.25)
	#await $hitflashPlayer.animation_finished
	await get_tree().create_timer(0.1 * 0.25).timeout
	global_position = UnlimitedRulebook.checkpoint
	UnlimitedRulebook.emit_signal("death")

func set_hurtbox_collision(val: bool) -> void:
	if val == true:
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", false)
	if val == false:
		$Marker2D/HurtBox/CollisionShape2D.set_deferred("disabled", true)

func set_collision_size(size):
	match size:
		"default":
			$Marker2D/HurtBox/CollisionShape2D.shape.radius = 6
			$Marker2D/HurtBox/CollisionShape2D.shape.height = 20
			$Marker2D/HurtBox/CollisionShape2D.position = Vector2(0, -10)
		"dash":
			$Marker2D/HurtBox/CollisionShape2D.shape.radius = 5
			$Marker2D/HurtBox/CollisionShape2D.shape.height = 10
			$Marker2D/HurtBox/CollisionShape2D.position = Vector2(0, -16)
		


func _on_jump_buffer_body_entered(_body: Node2D) -> void:
	inJumpBufferArea = true
	pass # Replace with function body.


func _on_jump_buffer_body_exited(_body: Node2D) -> void:
	inJumpBufferArea = false
	pass # Replace with function body.

func spawn_ghost():
	var ghost = AnimatedSprite2D.new()
	ghost.sprite_frames = anima.sprite_frames
	var faded_twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	faded_twink.tween_property(ghost, "modulate", Color.TRANSPARENT, 0.33)
	ghost.global_position = anima.global_position
	ghost.scale.x = $Marker2D.scale.x
	get_tree().root.add_child(ghost)
	ghost.play(anima.animation)
	ghost.frame = anima.frame
	ghost.pause()
	await get_tree().create_timer(0.33).timeout
	ghost.queue_free()


func _on_ghost_timer_timeout() -> void:
	spawn_ghost()
	pass

func _on_wall_jump_buffer_body_entered(_body: Node2D) -> void:
	inWallJumpBufferArea = true

func _on_wall_jump_buffer_body_exited(_body: Node2D) -> void:
	inWallJumpBufferArea = false


func _on_wall_jump_buffer_fader_timeout() -> void:
	bufferedWallJump = false

func choo_choo():
	#train 1 follow me
	#train 2 follow train 1
	#train 3 follow train 2
	for car_number in range(train.size()):
		if car_number == 0:
			train[car_number].global_position = lerp(train[car_number].global_position, 
			get_closest_point_on_circle(train[car_number].global_position, global_position, 20.0), 0.1)
		else:
			train[car_number].global_position = lerp(train[car_number].global_position, 
			get_closest_point_on_circle(train[car_number].global_position, 
			train[car_number-1].global_position, 20.0), 0.1)
	pass

func get_distance_to_circle_edge(target_point: Vector2, circle_center: Vector2, radius: float) -> float:
	# Get the distance from the target to the center
	var distance_to_center = target_point.distance_to(circle_center)
	# Subtract the radius to find the distance to the edge
	var distance_to_edge = distance_to_center - radius
	# Optional: Use abs() if the target point might be INSIDE the circle 
	# and you want the distance to the nearest edge rather than a negative number.
	return abs(distance_to_edge)

func get_closest_point_on_circle(target_point: Vector2, circle_center: Vector2, radius: float) -> Vector2:
	# Find the normalized direction vector from the center to the target
	var direction = circle_center.direction_to(target_point)
	# Multiply the direction by the radius and add it to the center position
	var closest_point = circle_center + (direction * radius)
	return closest_point

func stepper():
	if !$stepSounds.playing:
		if anima.animation == "run":
			if anima.frame in [1, 5]:
				$stepSounds.play()
		if anima.animation == "walk":
			if anima.frame in [3, 7]:
				$stepSounds.play()
		#if anima.animation == "idle":
			#if anima.frame in [0]:
				#$stepSounds.play()


func _on_dash_cooldown_timeout() -> void:
	onDashCooldown = false
