extends CharacterBody2D

enum States {
	Idle, #Fram och tillbaka ganska lågt
	Return, #Åk upp till idle höjden från slutet av förra state
	GroundSlam,
	GoAround #åk runt rummet längs väggarna
}

@export var current_state = States.Idle
var direction = Vector2.ZERO
var gravity = 1500

var damage = -1
var health = 20

@export var move_speed = 9500

@export var anim_player: AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer

#Idle variables
@onready var max_right = $Idle/RightMax.global_position
@onready var max_left = $Idle/LeftMax.global_position
@onready var turn_timer = $Idle/TurnTimer
var can_turn = true

#Return Variables
@onready var return_point = $Return/ReturnPoint.global_position

#Ground Slam varaiables
@onready var ground_collision = $GroundSlam/Area2D/CollisionShape2D
@onready var wait_timer = $GroundSlam/WaitTimer

func _ready():
	anim_player.play("Start")
	
	await anim_player.animation_finished
	change_state(States.Idle)
	attack_timer.start()

func change_state(new_state: States):
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	ground_collision.disabled = true
	if current_state != States.GroundSlam:
		global_position.y = 0
	
	if current_state == States.Idle:
		return_point = global_position
	
	current_state = new_state
	
	if new_state == States.Idle:
		direction = Vector2(1, 0)
	if new_state == States.Return:
		direction = Vector2(0, -1)

func _physics_process(delta):
	match current_state:
		States.Idle:
			Idle(delta)
		States.Return:
			Return(delta)
		States.GroundSlam:
			ground_slam(delta)
		States.GoAround:
			go_around(delta)

func choose_attack_state():
	randomize()
	var max = States.values().max()
	var min = States.values().min() + 2 #plus två för att ta bort idle, return
	
	var new_attack = randi_range(min, max)

func _unhandled_input(event):
	if event.is_action_pressed("BasicAttack"):
		change_state(States.GoAround)

func Return(delta):
	if global_position.distance_to(return_point) <= 1 and global_position.distance_to(return_point) >= -1:
			change_state(States.Idle)
	
	velocity = direction * (move_speed / 3) * delta
	move_and_slide()

func Idle(delta):
	if can_turn:
		if global_position.distance_to(max_left) <= 1 and global_position.distance_to(max_left) >= -1:
			direction.x = 1
			can_turn = false
			turn_timer.start()
		if global_position.distance_to(max_right) <= 1 and global_position.distance_to(max_right) >= -1:
			direction.x = -1
			can_turn = false
			turn_timer.start()
	
	velocity.x = direction.x * move_speed * delta
	move_and_slide()

func ground_slam(delta):
	if is_on_floor():
		#ändra state och slå på collision
		ground_collision.disabled = false
		if wait_timer.is_stopped():
			wait_timer.start()
	
	velocity.y += gravity * delta
	move_and_slide()

func go_around(delta):
	pass

func _on_turn_timer_timeout():
	can_turn = true

func get_damage():
	return damage

func _on_wait_timer_timeout():
	change_state(States.Return)

func _on_hurt_box_area_entered(area: Area2D):
	take_damage(area.get_damage())

func take_damage(damage_amount: int):
	#det är plus för att damage_amount är ett negativt tal
	health += damage_amount
	print(health)
	
	if health <= 0:
		#Boss fight är klart
		queue_free()

func _on_attack_timer_timeout():
	pass # Replace with function body.
