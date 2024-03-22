extends CharacterBody2D

enum States {
	Down,
	Up,
	Left,
	Right
}

var current_state = States.Left
var direction = "Left"

var move_speed = 1750

func exit(new_state: States):
	new_state = current_state
	
	velocity = Vector2.ZERO

func _physics_process(delta):
	match current_state:
		States.Down:
			pass
		States.Up:
			pass
		States.Left:
			Left(delta)
		States.Right:
			pass
	
	move_and_slide()

func Up(delta: float):
	pass

func Down(delta: float):
	pass

func Left(delta: float):
	var move_direction = -1
	
	velocity.x = move_direction * move_speed * delta

func Right(delta: float):
	pass
