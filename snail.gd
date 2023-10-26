class_name snail
extends CharacterBody2D

var health = 5

func _physics_process(_delta):
	
	pass

#take damage
func take_damage(amount:):
	
	health -= amount
