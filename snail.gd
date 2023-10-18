extends CharacterBody2D

var health = 5

func _physics_process(delta):
	
	pass

func take_damage(amount:):
	
	health -= amount
