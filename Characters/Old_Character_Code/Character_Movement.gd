extends CharacterBody2D

#Rasmus kod

const gravity = 500.0  # Adjust as needed
const move_speed = 150.0  # Adjust as needed
const jump_force = 150.0  # Adjust as needed
const max_jump_duration = 5  # Adjust as needed

var jumping = false
var jump_timer = 0.0

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	# Horizontal movement
	var move_direction = 0
	if Input.is_action_pressed("Left"):
		move_direction = -1
	if Input.is_action_pressed("Right"):
		move_direction = 1

	velocity.x = move_speed * move_direction

	# Jumping logic
	if is_on_floor():
		jumping = false
		jump_timer = 0.0
	else:
		jump_timer += delta

	if Input.is_action_pressed("Jump") and not jumping:
		velocity.y -= (jump_force * jump_force)
		jumping = true
		
		while(jumping):
			velocity.y -= (jump_force * jump_force)
			
			await get_tree().create_timer(1).timeout
	
	if jump_timer >= max_jump_duration:
		jumping = false
	

	# Move the character
	move_and_slide()
