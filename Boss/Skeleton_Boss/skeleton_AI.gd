extends CharacterBody2D

#Hildings kod

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
var health = 1

@export var move_speed = 9500

@export var anim_player: AnimationPlayer
@onready var attack_timer: Timer = $AttackTimer

@onready var coin_scene: PackedScene = preload("res://Characters/Dropables/soul_charge/soul_charge.tscn")
var coin_amount = 25

#Go Around variables
@onready var around_timer = $GoAround/AroundTimer
var current_dir = ""

#Return Variables
@onready var return_point = $Return/ReturnPoint.global_position

#Ground Slam varaiables
@onready var ground_collision = $GroundSlam/Area2D/CollisionShape2D
@onready var wait_timer = $GroundSlam/WaitTimer

func _ready():
	#Spela start cutscenen
	anim_player.play("Start")
	
	await anim_player.animation_finished
	#Starta boss fighten när cutscenen är klar
	change_state(States.Idle)
	attack_timer.start()

func change_state(new_state: States):
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	current_dir = ""
	
	#Om förra staten va idle eller return när den byter ska den se till att skeletets y värde är 0
	if current_state < 2:
		global_position.y = 0
	
	if current_state == States.Idle:
		#Ändra return piunkten till där den börjar med ground slam
		return_point = global_position
	if current_state == States.Return:
		#Starta attack colldownen så den inte bara spammar attacker
		attack_timer.start()
	
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
		_: #Körs om current state får en state som inte finns
			print("State does not exist")

func choose_attack_state():
	randomize()
	var max = States.values().max()
	var min = States.values().min() + 2 #plus två för att ta bort idle, return
	
	var new_attack_state = randi_range(min, max)
	
	change_state(new_attack_state)

func Return(delta):
	#Kolla om skeletet är när till return punkten och då byt state till idle
	if global_position.distance_to(return_point) <= 1 and global_position.distance_to(return_point) >= -1:
			change_state(States.Idle)
	
	velocity = direction * (move_speed / 3) * delta
	move_and_slide()

func Idle(delta):
	if is_on_wall():
		direction.x = -direction.x
	
	velocity.x = direction.x * move_speed * delta
	move_and_slide()

func ground_slam(delta):
	if is_on_floor():
		if wait_count == 0:
			wait_count += 1
			ground_collision.disabled = false
			wait_timer.start()
	
	velocity.y += gravity * delta
	move_and_slide()

func go_around(delta):
	if current_dir == "":
		velocity.y += gravity * delta
		
		if around_timer.is_stopped():
			around_timer.start()
	
	if is_on_floor():
		current_dir = "right"
	
	if is_on_wall() and current_dir == "down":
		pass
	else:
		if is_on_wall():
			if current_dir == "left":
				current_dir = "down"
				return
			current_dir = "up"
		if is_on_ceiling():
			current_dir = "left"
	
	match current_dir:
		"down":
			velocity.y += (move_speed / 5) * delta
			velocity.x = 0
		"left":
			velocity.y = 0
			velocity.x = -move_speed * delta
		"right":
			velocity.y = 0
			velocity.x = move_speed * delta
		"up":
			velocity.y -= (move_speed / 5) * delta
			velocity.x = 0
		_: #Allt annat som inte har en egen del
			pass
	
	move_and_slide()

func get_damage():
	return damage

func should_knockback():
	return true

func _on_hurt_box_area_entered(area: Area2D):
	take_damage(area.get_damage())

func take_damage(damage_amount: int):
	#det är plus för att damage_amount är ett negativt tal
	health += damage_amount
	#print(health)
	
	if health <= 0:
		death()

func _on_attack_timer_timeout():
	choose_attack_state()

func _on_around_timer_timeout():
	return_point = Vector2(global_position.x, 0)
	
	change_state(States.Return)

var wait_count = 0
func _on_wait_timer_timeout():
	if wait_count == 1:
		ground_collision.disabled = true
		wait_timer.start()
		wait_count += 1
	elif wait_count == 2:
		change_state(States.Return)
		wait_count = 0

func death():
	current_state = -1
	velocity = Vector2.ZERO
	direction = Vector2.ZERO
	
	anim_player.play("Death")
	
	#Spawn coins
	await get_tree().create_timer(1.5).timeout
	var spawn_pos = global_position
	for coin in coin_amount:
		var new_coin = coin_scene.instantiate()
		#Randomize spawn location
		new_coin.global_position = Vector2(spawn_pos.x + randf_range(-125, 125), spawn_pos.y)
		
		get_parent().call_deferred("add_child", new_coin)
		await get_tree().create_timer(randf_range(0.05, 0.1)).timeout

	#Ta bort från scenen
	await anim_player.animation_finished
	queue_free()
