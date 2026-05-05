extends CharacterBody2D

var speed = 130.0
var jumpVelocity = -400.0
@onready var anima = $Marker2D/anima
@onready var machine = $StateMachine
var dir = 1.0
var dashDuration = 0.33

var dashes = 0

var inJumpBufferArea = false
var bufferedJump = false

@export var cam : Camera2D

func _ready():
	UnlimitedRulebook.player = self
	
func _physics_process(delta):
	$DebugLabel.text = str(machine.get_state())
	
	if cam:
		if is_instance_valid(cam):
			UnlimitedRulebook.cam = cam
	
	#Dashing
	if Input.is_action_just_pressed("run"):
		if dashes > 0:
			machine.change_state_to("dash")
			dashes -= 1
	
	#Jumping
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
	
	#Falling
	if !is_on_floor() && machine.get_state() not in ["walled", "dash"]:
		#velocity.y += get_gravity().y * delta
		velocity.y = clamp(velocity.y + get_gravity().y * delta, jumpVelocity*2, -jumpVelocity*2)
		if machine.get_state() not in ["roll", "jump"]:
			machine.change_state_to("fall")
	
	#Wall Slide
	if is_on_wall() && velocity.y > -40.0:
		machine.change_state_to("walled")
	
	#Rolling
	if Input.is_action_just_pressed("misc"):
		machine.change_state_to("roll")
	
	#Walking
	var dir_ = Input.get_axis("left", "right")
	if machine.get_state() not in ["roll", "dash"]:
		if dir_:
			dir = dir_
			if Input.is_action_pressed("run"):
				velocity.x = lerp(velocity.x, dir*speed*1.6, 0.1)
				if is_on_floor(): machine.change_state_to("run")
			else:
				velocity.x = lerp(velocity.x, dir*speed, 0.1)
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

func flip(foo) -> void:
	match foo:
		"left":
			$Marker2D.scale.x = -1
		"right":
			$Marker2D.scale.x = 1

func death():
	UnlimitedRulebook.frameFreeze(0.1, 0.25)
	#await $hitflashPlayer.animation_finished
	await get_tree().create_timer(0.1 * 0.25).timeout
	global_position = UnlimitedRulebook.checkpoint

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
