extends CharacterBody2D

var player = null
var garvity : int = 900.0
var speed : int = 100.0
var chase = false
var luanch_back = false
var stop = false

func _physics_process(delta):
	
	#pausa allt
	
	if stop == false:
		
		#spöket gravitation
		
		if not is_on_floor() and chase == false:
			
			velocity.y += garvity * delta
		
		#spöket jagar
		
		if chase == true and luanch_back == false:
			
			var direction = (player.position - position).normalized()
			
			velocity = direction * speed
		
		#skickar till baka spelaren
		
		if luanch_back == true:
			
			var disctanse = (player.position - position).normalized()
			
			velocity = disctanse * speed * -2
		
		move_and_slide()

#känner när spelaren går inom arean

func _on_player_detect_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	if body.name == Game.player_name:
		
		player = body
		
		chase = true

#när spelaren lämnar arean

func _on_player_detect_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	
	if body.name == Game.player_name:
		
		chase = false
		
		velocity.x = 0

#kollar när spöket nuddar spelaren

func _on_hit_box_body_entered(body):
	
	if body.name == Game.player_name:
		
		Game.player_health  -= 1
		
		luanch_back = true

#sträckan man skickas till baka när man skadar spelare

func _on_luanch_back_area_body_exited(body):
	
		if body.name == Game.player_name:
			
			luanch_back = false
			
			stop = true
			
			await get_tree().create_timer(1).timeout
			
			stop = false
