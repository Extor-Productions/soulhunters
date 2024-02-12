class_name my_hurt_box
extends Area2D


func _ready():
	
	collision_layer = 0
	
	collision_mask = 2

	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: enemy_hit_box):
	
	if hitbox == null:
		
		return
	
	if hitbox.name == "enemy_hit_box":
		
		if owner.has_method("take_damage"):
			
			owner.take_damage(hitbox.damage)
