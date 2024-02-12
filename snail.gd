class_name snail
extends CharacterBody2D
var my_position = Vector2.ZERO
var health = 5
var back = false

@onready var korv_toimer = $Korvtimer
@onready var Indesturcteble_timer = $Indestrukteble_timer
var _knockback = false

signal knockback(korv)

func _physics_process(delta):
	
	alive()
	
	if _knockback == true:
		velocity.x += 25
	if back == true:
		velocity.x -= 5
		if global_position.distance_to(my_position) <= 2:
			emit_signal("knockback", false)
			back = false
			velocity.x = 0
	
	move_and_slide()

#take damage
func take_damage(amount:):
	set_collision_layer(4)
	my_position = global_position
	
	emit_signal("knockback", true)
	
	korv_toimer.start()
	
	Indesturcteble_timer.start()
	
	$enemy_hurt_box/CollisionShape2D.set_deferred("disabled", true)
	
	_knockback = true
	
	health -= amount

func alive():
	
	if health <= 0:
		
		queue_free()

func _on_korvtimer_timeout():
	_knockback = false
	back = true

func _on_indestrukteble_timer_timeout():
	set_collision_layer(0)
	$enemy_hurt_box/CollisionShape2D.set_deferred("disabled", false)
