class_name enemy_hurt_box
extends Area2D

func _init():
	
	collision_layer = 0
	
	collision_mask = 3

func _ready():
	
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: my_hit_box):
	
	if hitbox == null:
		
		return
	
	if owner.has_method("take_damage"):
		
		owner.take_damage(hitbox.damage)
