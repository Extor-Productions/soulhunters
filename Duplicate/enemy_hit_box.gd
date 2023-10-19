class_name enemy_hit_box
extends Area2D

@export var damage = 10


func _ready():
	
	collision_layer = 2
	
	collision_mask = 0

