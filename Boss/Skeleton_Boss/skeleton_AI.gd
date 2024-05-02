extends CharacterBody2D

enum States {
	Idle, #Fram och tillbaka ganska lågt
	Return, #Åk upp till idle höjden från slutet av förra state
	GroundSlam,
}

var current_state = States.Idle
var direction = Vector2.ZERO
var gravity = 9.81

var damage = -1

@export var move_speed = 9500

@onready var anim_player = $AnimationPlayer

#Idle variables
@onready var max_right = $Idle/RightMax.global_position
@onready var max_left = $Idle/LeftMax.global_position
@onready var turn_timer = $Idle/TurnTimer
var can_turn = true

#Return Variables
@onready var return_point = $Return/ReturnPoint

#Ground Slam varaiables
@onready var ground_collision = $GroundSlam/Area2D/CollisionShape2D
@onready var wait_timer = $GroundSlam/WaitTimer

func change_state(new_state: States):
	direction = Vector2.ZERO
	velocity = direction
	
	ground_collision.disabled = true
	
	if current_state == States.Idle:
		return_point.global_position = global_position
	
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

func _ready():
	change_state(States.Idle)

func choose_attack_state():
	randomize()
	var max = States.values().max()
	var min = States.values().min() + 2 #plus två för att ta bort idle, return och wait
	
	var new_attack = randi_range(min, max)

func Return(delta):
	velocity = direction * move_speed * delta
	
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
	
	velocity.y += gravity * delta
	move_and_slide()

func _on_turn_timer_timeout():
	can_turn = true

func get_damage():
	return damage

func _on_wait_timer_timeout():
	change_state(States.Return)
