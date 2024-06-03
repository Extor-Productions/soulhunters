extends CharacterBody2D

#Hildings kod
@onready var movement_controller = $Movment_Node
@onready var warrior_node = $Warrior

@onready var health_bar = $Health
@onready var player_ui = $PlayerUI

@export var health = 10
@export var damage = -1

@export var can_move = true

var knockback = false

func _ready():
	#Reseta spelarens animation
	$AnimationPlayer.play("RESET")

func _physics_process(delta):
	#Kolla spelaren kan röra sig
	if can_move:
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

func take_damage(amount: int, should_knockback: bool):
	if should_knockback:
		#Aktivera knockback
		knockback = true
		$KnockbackTimer.start()
	
	#ändra hälksan med amount
	health += amount
	#Säg till spelarens health bar att ändra med amount
	health_bar.change_health(amount)
	
	if health <= 0:
		GlobalSignals.emit_signal("player_death")

func _on_knockback_timer_timeout():
	#Stäng av knockback
	knockback = false

func _on_my_hurt_box_area_entered(area: Area2D):
	take_damage(area.get_damage(), area.should_knockback())

func get_damage():
	return damage

func get_damage_direction():
	return movement_controller.damage_dir()

