extends CharacterBody2D

enum States {
	Down,
	Up,
	Left,
	Right
}

var current_state = States.Left

var move_speed = 15000

@onready var down_1 = $"Vision/Down 1"
@onready var down_2 = $"Vision/Down 2"
@onready var front = $Vision/Front

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
