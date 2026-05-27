extends Area2D

var active = true
@export var father : Node2D
@export var healthComp : Node
@export var InvulnTimer : Timer

var invuln = false

func _ready() -> void:
	if InvulnTimer:
		if is_instance_valid(InvulnTimer):
			InvulnTimer.timeout.connect(_on_invuln_timeout)

func damage(attack, attacker):
	if !active:
		return
	if invuln:
		return
	if father.has_method("knockback"):
		father.knockback(attacker)
	if healthComp:
		healthComp.damage(attack)
		if father:
			if father.has_node("hitflashPlayer"):
				father.get_node("hitflashPlayer").play("hitflash")
	if InvulnTimer:
		if is_instance_valid(InvulnTimer):
			InvulnTimer.start()
		invuln = true


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("hurty"):
		damage(1, self)

func _on_invuln_timeout():
	invuln = false
