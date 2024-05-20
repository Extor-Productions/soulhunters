extends Control

#Hildings kod

@onready var bar = $ProgressBar

var health = 10

func set_health(new_health):
	health = new_health
	
	bar.max_value = health

func change_health(amount):
	health += amount
	
	bar.value = health
