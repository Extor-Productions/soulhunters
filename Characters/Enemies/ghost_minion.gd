extends CharacterBody2D

enum States {
	Chase,
	Idle,
	Return,
	Launch
}

var current_state = States.Idle

@export var spawn_point: Marker2D

var player : CharacterBody2D = null
var gravity : int = 900
var speed : int = 5000

var damage := -1
var health := 5

func exit(new_state: States):
	velocity = Vector2.ZERO
	player = null
	
	current_state = new_state

func _physics_process(delta):
	match current_state:
		States.Return:
			pass
		States.Idle:
			idle(delta)
		States.Launch:
			pass
		States.Chase:
			chase(delta)
	
	move_and_slide()

func idle(delta: float):
	#Åk ner i marken
	velocity.y += gravity * delta

func chase(delta: float):
	#Jaga spelaren
	var player_direction = global_position.direction_to(player.global_position)
	
	velocity = player_direction * speed * delta

func Return(delta: float):
	#Återgå till spawn pungt
	pass

func take_damage(amount):
	health += amount

func get_damage():
	return damage

func should_knockback():
	return false

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		take_damage(area.get_parent().get_damage())

func _on_player_detect_body_entered(body):
	exit(States.Chase)
	
	player = body

func _on_player_detect_body_exited(body):
	exit(States.Return)
