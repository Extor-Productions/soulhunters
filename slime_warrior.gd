extends CharacterBody2D

@export var speed : int = 150
@export var jump_force : int = 255
@export var second_jump_force : int = 200
@export var gravity : int = 900
@export var max_jumps : int = 2
@export var current_jumps : int = 0

#kollar om det är rätt klass
func exist_start():
	if Game._class != 0:
		
		queue_free()
		
	if Game._class == 0:
		
		Game.player_name = "slime_warrior"

func _process(_delta):
	
	exist_start()

func _physics_process(delta):
	
	move_x_axis()
	
	_gravity(delta)
	
	jump()
	
	move_and_slide()

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
			
			$AnimatedSprite2D.play("Jump")

func move_x_axis():
	
	var direction = Input.get_axis("Left", "Right")
	
	if direction:
		
		velocity.x = direction * speed
		
		if is_on_floor():
			$AnimatedSprite2D.play("Run")
		
	else:
		
		velocity.x = 0
		
		if is_on_floor():
			
			$AnimatedSprite2D.play("Idle")
	
	#rotate höger vänster
	
	if direction == 1:
		
		$AnimatedSprite2D.flip_h = true
		
	elif direction == -1:
		
		$AnimatedSprite2D.flip_h = false

func _gravity(delta):
	
	if not is_on_floor():
		
		velocity.y += gravity * delta
		
		if velocity.y > 0:
			$AnimatedSprite2D.play("Fall")

func take_damage(amount):
	
	return
