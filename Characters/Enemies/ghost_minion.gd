extends CharacterBody2D

@export var spawn_point: Marker2D

var player = null
var gravity : int = 900
var speed : int = 100

var chase = false
var launch_back = false

var stop = false
var return_spawn = false

var damage := -1
var health := 5

func _physics_process(delta):
	if health <= 0:
		queue_free()
	
	#Saker den ska göra:
	#Chase player : klar
	#Launch back : klar
	#Stop : klar / Återgå till spawn
	
	if chase:
		#Chase player
		if player != null:
			var dir = global_position.direction_to(player.global_position)
			
			velocity = dir * speed
	elif launch_back:
		if player != null:
			var dir = -(global_position.direction_to(player.global_position))
			
			velocity = dir * (speed / 2)
	elif return_spawn:
		# Återgår till spawn
		if spawn_point != null:
			var dir = global_position.direction_to(spawn_point.global_position)
			
			if global_position.distance_to(spawn_point.global_position) <= 1:
				return_spawn = false
				return
			
			while global_position.distance_to(spawn_point.global_position) != 0:
				velocity = dir * speed
				
				move_and_slide()
				await get_tree().create_timer(1).timeout
			
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func take_damage(amount):
	health += amount
	
	$LaunchTimer.start()
	if !launch_back:
		chase = false
		
	launch_back = true

#känner när spelaren går inom arean
func _on_player_detect_body_shape_entered(body):
	if body.is_in_group("Player"):
		player = body
		launch_back = false
		chase = true

#när spelaren lämnar arean
func _on_player_detect_body_shape_exited(body):
	if body.is_in_group("Player"):
		#Ta bort spelaren från spöket
		player = null
		chase = false
		launch_back = false
		
		return_spawn = true

#Kollar när spöket har attackerat spelaren
func _on_hurt_box_body_entered(body):
	if body.is_in_group("Player"):
		$LaunchTimer.start()
		
		if !launch_back:
			chase = false
		
		launch_back = true

func get_damage():
	return damage

func should_knockback():
	return false

func _on_launch_timer_timeout():
	launch_back = false
	
	if player != null:
		chase = true

func _on_hit_box_area_entered(area: Area2D):
	if area.is_in_group("Player"):
		take_damage(area.get_parent().get_damage())
