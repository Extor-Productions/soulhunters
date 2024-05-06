extends CharacterBody2D

@onready var movement_controller = $Movment_Node
@onready var warrior_node = $Warrior

@onready var health_bar = $Health

@export var health = 10
@export var damage = -1

var knockback = false

func _ready():
	$AnimationPlayer.play("RESET")

func _physics_process(delta):
	move(delta)
	movement_controller.dash(delta)
	
	warrior_node.slash()

func move(delta: float):
	#Ska alltid vara först
	movement_controller.apply_gravity(delta)
	
	if not knockback:
		movement_controller.move(delta)
		movement_controller.jump(delta)
	else:
		movement_controller.knockback(delta)

func take_damage(damage_amount: int, should_knockback: bool):
	if should_knockback:
		#Aktivera knockback
		knockback = true
		$KnockbackTimer.start()
	
	health += damage_amount
	health_bar.change_health(damage_amount)
	
	#if health <= 0:
	#	queue_free()

func _on_knockback_timer_timeout():
	#Stäng av knockback
	knockback = false

func _on_my_hurt_box_area_entered(area: Area2D):
	if area.is_in_group("Enemy"):
		take_damage(area.get_parent().get_damage(), area.get_parent().should_knockback())

func get_damage():
	return damage

func get_damage_direction():
	return movement_controller.damage_dir()

