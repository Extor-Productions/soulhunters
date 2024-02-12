extends CharacterBody2D

@export var speed : int = 150
@export var jump_force : int = 255
@export var second_jump_force : int = 200
@export var gravity : int = 900
@export var max_jumps : int = 2
@export var current_jumps : int = 0

@onready var up_slash = $my_hit_box2

#kollar om det är rätt klass
func exist_start():
	
	if Game._class != 0:
		
		queue_free()
		
	if Game._class == 0:
		
		Game.player_name = "slime_warrior"
	
	$AnimationPlayer.play("RESET")
	
	$AnimatedSprite2D.play("Idle")

func _ready():
	
	exist_start()

func _physics_process(delta):
	
	slash()
	
	move_x_axis()
	
	_gravity(delta)
	
	jump()
	
	move_and_slide()

func slash():
	
	if Input.is_action_just_pressed("BasicAttack"):
		
		if Input.is_action_pressed("up"):
			
			up_slash.scale.y = -1
			
			#$AnimationPlayer
			
		elif Input.is_action_pressed("dwon"):
			
			up_slash.scale.y = 1
			
			#$AnimationPlayer
			
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
			
			#$AnimatedSprite2D.play("Jump")

func move_x_axis():
	
	var direction = Input.get_axis("Left", "Right")
	
	if direction:
		
		velocity.x = direction * speed
		
		if is_on_floor():
			#$AnimatedSprite2D.play("Run")
			pass
		
	else:
		
		velocity.x = 0
		
		if is_on_floor():
			
			#$AnimatedSprite2D.play("Idle")
			pass
	
	#rotate höger vänster
	
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
			#$AnimatedSprite2D.play("Fall")
			pass

func take_damage(amount):
	
	return

func knock_back():
	pass
	
