extends CharacterBody2D

@export var speed : int = 150
@export var jump_force : int = 255
@export var second_jump_force : int = 200
@export var garvity : int = 900
@export var max_jumps : int = 2
@export var current_jumps : int = 0
var take_damage = Game.player_health - 1

#kollar om det är rätt klass
func exist_start():
	if Game._class != 0:
		
		queue_free()
		
	if Game._class == 0:
		
		Game.player_name = "slime_warrior"

func _process(_delta):
	
	exist_start()
	#kollar när du tar skada
	
	if Game.player_health == take_damage:
		
		take_damage = Game.player_health - 1

func _physics_process(delta):
	
	if is_on_floor():
		
		current_jumps = 0
		
	#movment on x axes
	
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
	
	
	#gravity
	if not is_on_floor():
		
		velocity.y += garvity * delta
		
		if velocity.y > 0:
			$AnimatedSprite2D.play("Fall")
	
	#Jump
	jump()
	
	move_and_slide()

#gör att man hoppar
func jump():
	if Input.is_action_just_pressed("Jump") and current_jumps < max_jumps:
			if current_jumps == 0:
				
					velocity.y -= jump_force
					
					current_jumps += 1
					#Double Jump
			elif current_jumps == 1:
					
					velocity.y = 0
					
					velocity.y -= second_jump_force
				
			current_jumps += 1
			
			$AnimatedSprite2D.play("Jump")

func warrior(_delta):
	
	if Input.is_action_just_pressed("Attack"):
		
		$AnimatedSprite2D/AnimationPlayer.play("slash")
