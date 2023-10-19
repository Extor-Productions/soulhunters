class_name my_hit_box
extends Area2D

@export var damage = 10


func _ready():
	
	collision_layer = 3
	
	collision_mask = 0


