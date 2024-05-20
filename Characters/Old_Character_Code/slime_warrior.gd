extends CharacterBody2D

#Rasmus kod

@export var speed : int = 150
@export var jump_force : int = 255
@export var second_jump_force : int = 200
@export var gravity : int = 900
@export var max_jumps : int = 2
@export var current_jumps : int = 0

var health := 10

@onready var up_slash = $HitBox2
@onready var health_bar = $Health

var damage := -1
var damage_dir = 1
var knockback = false

#kollar om det är rätt klass
func exist_start():
	#Fråga om
	if Game._class != 0:
		queue_free()
	
	if Game._class == 0:
		Game.player_name = "slime_warrior"
	
	$AnimationPlayer.play("RESET")
	$AnimatedSprite2D.play("Idle")

func _ready():
	exist_start()
	
	health_bar.set_health(health)

func _physics_process(delta):
	_gravity(delta)
	
	if health <= 0:
		# Avsluta spel?
		get_tree().quit()
	
	#Knockback
	if knockback:
		#Kan behöva ändras
		velocity.x += 50 * damage_dir
	else:
		slash()
		move_x_axis(delta)
		jump()
	
	move_and_slide()

func slash():
	if Input.is_action_just_pressed("BasicAttack"):
		if Input.is_action_pressed("up"):
			up_slash.scale.y = -1
		elif Input.is_action_pressed("down"):
			up_slash.scale.y = 1
		else:
			$AnimationPlayer.play("Slash")

func jump():
	if is_on_floor():
		current_jumps = 0
	
	if Input.is_action_just_pressed("Jump") and current_jumps < max_jumps:
			if current_jumps == 0:
				velocity.y -= jump_force
				#Double Jump
			elif current_jumps == 1:
				velocity.y = 0
				velocity.y -= second_jump_force
			
			current_jumps += 1

func move_x_axis(delta):
	var direction = Input.get_axis("Left", "Right")
	
	# Ändra damage dir beroende på vilket håll man går åt
	if direction != 0:
		damage_dir = -direction
	
	if direction:
		velocity.x = direction * speed
		if is_on_floor():
			# Play run animation
			pass
	else:
		velocity.x = 0
		if is_on_floor():
			# Play idle animation
			pass
	
	# Rotera spelaren
	if direction == -1:
		scale.y = -1
		rotation_degrees = 180
	elif direction == 1:
		scale.y = 1
		rotation_degrees = 0

func _gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
		if velocity.y > 0:
			# Play animation fall
			pass

func get_damage():
	return damage

func get_damage_direction():
	return damage_dir

func take_damage(amount):
	$KnockbackTimer.start()
	knockback = true
	
	health += amount
	health_bar.change_health(amount)

func _on_knockback_timer_timeout():
	knockback = false

func _on_my_hurt_box_area_entered(area: Area2D):
	if area.is_in_group("Enemy"):
		take_damage(area.get_parent().get_damage())
