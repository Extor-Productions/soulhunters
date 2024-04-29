extends CharacterBody2D

enum States {
	Idle, #Fram och tillbaka ganska lågt
	Return, #Åk upp till idle höjden från slutet av förra state
	GroundSlam,
}

var current_state = States.Idle
var direction = Vector2.ZERO

@onready var anim_player = $AnimationPlayer

#Idle variables
@onready var max_right = $Idle/RightMax.global_position
@onready var max_left = $Idle/LeftMax.global_position
@onready var turn_timer = $Idle/TurnTimer
var can_turn = true

@export var idle_move_speed = 9500

#Return Variables
@onready var return_point = $Return/ReturnPoint

var damage = -1

func change_state(new_state: States):
	direction = Vector2.ZERO
	velocity = direction
	
	return_point.global_position = global_position
	
	current_state = new_state
	
	if new_state == States.Idle:
		direction = Vector2(1, 0)
	if new_state == States.Return:
		pass

func _ready():
	change_state(States.Idle)

func _physics_process(delta):
	match current_state:
		States.Idle:
			Idle(delta)
		States.Return:
			Return()
		States.GroundSlam:
			pass

func choose_state():
	randomize()
	var max = States.values().max()
	var min = States.values().min() + 2 #plus två för att ta bort idle och return
	
	var new_attack = randi_range(min, max)

func Return():
	pass

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
	
	velocity.x = direction.x * idle_move_speed * delta
	move_and_slide()

func _on_turn_timer_timeout():
	can_turn = true

func get_damage():
	return damage
