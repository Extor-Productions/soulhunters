extends Area2D

#Hildings kod

@export var damage = -1

func get_damage():
	return damage

func get_damage_direction():
	return -1

func should_knockback():
	return false
