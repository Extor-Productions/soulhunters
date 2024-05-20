extends Node2D

#Hildings kod

@onready var parent: CharacterBody2D = self.get_parent()
@onready var animation_player: AnimationPlayer = self.get_parent().get_node("AnimationPlayer")

@onready var up_slash = self.get_parent().get_node("Verticall/HitBox")
@onready var verticall: Node2D = self.get_parent().get_node("Verticall")

@onready var attack1_timer = $Attack1_Cooldown

var can_attack_1 = true

func slash():
	#Attack one
	if Input.is_action_just_pressed("BasicAttack") and can_attack_1:
		if Input.is_action_pressed("up"):
			verticall.scale.y = 1
			
			animation_player.play("up_slash")
		elif Input.is_action_pressed("down"):
			verticall.scale.y = -1
			
			animation_player.play("up_slash")
		else:
			animation_player.play("slash")
		
		can_attack_1 = false
		attack1_timer.start()

func _on_attack_1_cooldown_timeout():
	can_attack_1 = true
