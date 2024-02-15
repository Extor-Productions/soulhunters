extends Node2D

@onready var parent: CharacterBody2D = self.get_parent()
@onready var animation_player: AnimationPlayer = self.get_parent().get_node("AnimationPlayer")

@onready var up_slash: Area2D = self.get_parent().get_node("HitBox2")
@onready var up_slash_sprite: AnimatedSprite2D = self.get_parent().get_node("YSlashSprite")

@onready var attack1_timer = $Attack1_Cooldown

var can_attack_1 = true

func slash():
	#Attack one
	if Input.is_action_just_pressed("BasicAttack") and can_attack_1:
		if Input.is_action_pressed("up"):
			up_slash.scale.y = -1
			up_slash_sprite.scale.y = -1
			
			print(up_slash_sprite.scale.y)
			animation_player.play("up_slash")
		elif Input.is_action_pressed("down"):
			up_slash.scale.y = 1
			up_slash_sprite.scale.y = 1
			
			print(up_slash_sprite.scale.y)
			animation_player.play("up_slash")
		else:
			animation_player.play("Slash")
		
		can_attack_1 = false
		attack1_timer.start()

func _on_attack_1_cooldown_timeout():
	can_attack_1 = true
