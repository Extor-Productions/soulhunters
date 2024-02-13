class_name snail
extends StaticBody2D

var my_position = Vector2.ZERO
var health = 5
var damage = -1

var back = false

@onready var knockback_timer = $Knockback_timer
@onready var Indesturcteble_timer = $Indestrukteble_timer

signal knockback(knockback, dir)

func _physics_process(delta):
	if health <= 0:
		queue_free()

#take damage
func take_damage(amount, dir):
	my_position = global_position
	
	emit_signal("knockback", true, dir)
	
	knockback_timer.start()
	Indesturcteble_timer.start()
	
	#Gör så att sniglen är odödlig en stund efter den har tagit skada
	$enemy_hurt_box/CollisionShape2D.set_deferred("disabled", true)
	
	health += amount

func _on_korvtimer_timeout():
	emit_signal("knockback", false, 0)

func _on_indestrukteble_timer_timeout():
	set_collision_layer(0)
	$enemy_hurt_box/CollisionShape2D.set_deferred("disabled", false)

func _on_enemy_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		take_damage(area.get_parent().get_damage(), area.get_parent().get_damage_direction())

func get_damage():
	return damage
