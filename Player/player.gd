extends CharacterBody2D

var speed = 130.0
var jumpVelocity = -400.0
@onready var anima = $Marker2D/anima
@onready var machine = $StateMachine
var dir = 1.0
var dashDuration = 0.33

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
		machine.change_state_to("dash")
	
	#Jumping
	if Input.is_action_just_pressed("jump"):
		if machine.get_state() == "walled":
			velocity.x = get_wall_normal().x * speed*3.2
			if get_wall_normal().x == 1.0:
				flip("right")
			if get_wall_normal().x == -1.0:
				flip("left")
		machine.change_state_to("jump")
	
	#Falling
	if !is_on_floor() && machine.get_state() not in ["walled", "dash"]:
		velocity.y += get_gravity().y * delta
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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		$"../Coins/Coin".coins +=1
		$"../Coins/Coin".score +=1
