extends Node2D

#Hildings kod

#Default values
@export var move_speed: int = 10000

@export var knockback_force: int = 5000
var knockback_direction: int = -1

@onready var dash_timer = $dash_timer
@onready var dash_timer2 = $dash_timer2
var dashing = false
var movment = true

@export var dash_force: int = 133333
var can_dash = true

@export var gravity: float = 900

@export var jump_height: int = 255
@export var max_jumps: int = 2
var current_jumps: int = 0

@onready var parent: CharacterBody2D = self.get_parent()

func move(delta: float):
	if movment:
		#Ta inputen från tangentbordet och gör en variablel av det
		var move_direction = Input.get_axis("Left", "Right")
		
		#Rör på spelaren
		if move_direction != 0:
			knockback_direction = -move_direction
			
			#Ändra spelarens velocity.x
			parent.velocity.x = move_direction * move_speed * delta
		else:
			parent.velocity.x = 0
		
		# Rotera spelaren
		if move_direction == -1:
			parent.scale.y = -1
			parent.rotation_degrees = 180
		elif move_direction == 1:
			parent.scale.y = 1
			parent.rotation_degrees = 0
		
		parent.move_and_slide()
#Rasmus kod
func dash(delta):
	if Input.is_action_just_pressed("dash") and !dashing and can_dash:
		dash_timer.start()
		dash_timer2.start()
		dashing = true
		movment = false
		can_dash = false
		
		while dashing:
			
			parent.velocity.x += dash_force * delta * -knockback_direction
			await get_tree().create_timer(.1).timeout
	
	parent.move_and_slide()

#Hildings kod
func apply_gravity(delta):
	if not parent.is_on_floor():
		parent.velocity.y += gravity * delta

func jump(delta):
	#Om spelaren är på marken reseta hur många hop spelaren har gjort
	if parent.is_on_floor() or parent.is_on_ceiling() or parent.is_on_wall():
		current_jumps = 0
	
	
	if Input.is_action_just_pressed("Jump") and current_jumps < max_jumps:
			if current_jumps == 0:
				parent.velocity.y -= jump_height
				#Double Jump
			elif current_jumps == 1:
				parent.velocity.y = 0
				parent.velocity.y -= jump_height
			
			current_jumps += 1

func knockback(delta: float):
	parent.velocity.x += knockback_force * knockback_direction * delta
	
	parent.move_and_slide()

func damage_dir():
	return knockback_direction

#Rasmus kod
func _on_dash_timer_timeout():
	dashing = false
	parent.velocity.x = 0
	movment = true

func _on_dash_timer_2_timeout():
	can_dash = true
