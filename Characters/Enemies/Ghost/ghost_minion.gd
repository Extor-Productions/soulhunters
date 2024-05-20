extends CharacterBody2D

#Hildings kod

enum States {
	Chase,
	Idle,
	Return,
	Launch
}

@onready var coin = preload("res://Characters/Dropables/soul_charge/soul_charge.tscn").instantiate()

var current_state = States.Idle

@export var spawn_point: Marker2D

var player : CharacterBody2D = null
var gravity : int = 900
var speed : int = 5000

var damage := -1
var health := 5

func exit(new_state: States):
	velocity = Vector2.ZERO
	
	current_state = new_state

func _physics_process(delta):
	#Kolla vilken state spöket är i och kör rätt funktion
	match current_state:
		States.Return:
			Return(delta)
		States.Idle:
			idle(delta)
		States.Launch:
			launch(delta)
		States.Chase:
			chase(delta)
	
	move_and_slide()

func launch(delta: float):
	#Skicka tillbaka spöket när den har attackerat
	var launch_direction = -(global_position.direction_to(player.global_position))
	
	velocity = (speed / 2) * launch_direction * delta

func idle(delta: float):
	#Åk ner i marken
	velocity.y += gravity * delta

func chase(delta: float):
	#Jaga spelaren
	var player_direction = global_position.direction_to(player.global_position)
	
	velocity = player_direction * speed * delta

func Return(delta: float):
	#Återgå till spawn pungt
	if spawn_point == null:
		exit(States.Idle)
	else:
		var spawn_direction = global_position.direction_to(spawn_point.global_position)
		
		velocity = spawn_direction * speed * delta
		
		#Om spöket är när tilbaka till sin spawn point så byt state till idle
		if global_position.distance_to(spawn_point.global_position) <= 1 and global_position.distance_to(spawn_point.global_position) >= -1:
			exit(States.Idle)

func take_damage(amount):
	health += amount
	
	if health <= 0:
		spawn_coin()
		
		queue_free()

func get_damage():
	return damage

func should_knockback():
	return false

func _on_hit_box_area_entered(area: Area2D):
	take_damage(area.get_damage())

func _on_player_detect_body_entered(body):
	exit(States.Chase)
	
	player = body

func _on_player_detect_body_exited(_body):
	player = null
	
	if spawn_point != null:
		exit(States.Return)
	else:
		exit(States.Idle)

func _on_hurt_box_body_entered(body):
	$LaunchTimer.start()
	exit(States.Launch)

func _on_launch_timer_timeout():
	if current_state == States.Launch:
		exit(States.Chase)

func spawn_coin():
	coin.global_position = global_position
	
	get_parent().call_deferred("add_child", coin)
